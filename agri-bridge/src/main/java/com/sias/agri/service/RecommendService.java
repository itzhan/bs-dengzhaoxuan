package com.sias.agri.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.entity.Order;
import com.sias.agri.entity.OrderItem;
import com.sias.agri.entity.Product;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 基于物品的协同过滤推荐服务
 * <p>
 * 算法原理：从历史订单中提取 "用户-商品" 购买关系矩阵，
 * 计算商品之间的余弦相似度，为目标用户推荐其未购买过但与已购商品相似的商品。
 */
@Service
public class RecommendService {

    private final OrderService orderService;
    private final OrderItemService orderItemService;
    private final ProductService productService;

    public RecommendService(OrderService orderService,
                            OrderItemService orderItemService,
                            ProductService productService) {
        this.orderService = orderService;
        this.orderItemService = orderItemService;
        this.productService = productService;
    }

    /**
     * 为指定用户生成推荐商品列表
     *
     * @param userId 目标用户ID
     * @param topN   推荐数量
     * @return 推荐商品列表
     */
    public List<Product> recommend(Long userId, int topN) {
        // 1. 获取所有订单及其明细，构建 用户->商品集合 的映射
        List<Order> allOrders = orderService.list();
        List<OrderItem> allItems = orderItemService.list();

        // orderId -> buyerId
        Map<Long, Long> orderBuyerMap = allOrders.stream()
                .collect(Collectors.toMap(Order::getId, Order::getBuyerId, (a, b) -> a));

        // 构建 用户-商品 购买矩阵: userId -> Set<productId>
        Map<Long, Set<Long>> userProducts = new HashMap<>();
        for (OrderItem item : allItems) {
            Long buyerId = orderBuyerMap.get(item.getOrderId());
            if (buyerId != null) {
                userProducts.computeIfAbsent(buyerId, k -> new HashSet<>()).add(item.getProductId());
            }
        }

        Set<Long> targetUserProducts = userProducts.getOrDefault(userId, Collections.emptySet());

        // 如果用户没有购买记录，返回热门商品
        if (targetUserProducts.isEmpty()) {
            return getPopularProducts(allItems, topN);
        }

        // 2. 构建商品-用户倒排索引: productId -> Set<userId>
        Map<Long, Set<Long>> productUsers = new HashMap<>();
        for (Map.Entry<Long, Set<Long>> entry : userProducts.entrySet()) {
            for (Long pid : entry.getValue()) {
                productUsers.computeIfAbsent(pid, k -> new HashSet<>()).add(entry.getKey());
            }
        }

        // 3. 计算候选商品得分（基于物品的协同过滤）
        //    对于用户已购的每个商品 i，找到也购买了 i 的其他用户购买的商品 j，
        //    累加 j 的得分 = sum( 1 / log(1 + |N(u)|) )，N(u) 为用户 u 购买的商品数
        Map<Long, Double> candidateScores = new HashMap<>();

        for (Long purchasedPid : targetUserProducts) {
            Set<Long> coUsers = productUsers.getOrDefault(purchasedPid, Collections.emptySet());
            for (Long coUserId : coUsers) {
                if (coUserId.equals(userId)) continue;
                Set<Long> coUserProducts = userProducts.get(coUserId);
                double weight = 1.0 / Math.log(1 + coUserProducts.size());
                for (Long candidatePid : coUserProducts) {
                    if (!targetUserProducts.contains(candidatePid)) {
                        candidateScores.merge(candidatePid, weight, Double::sum);
                    }
                }
            }
        }

        // 4. 按得分排序，取 topN
        List<Long> recommendedIds = candidateScores.entrySet().stream()
                .sorted(Map.Entry.<Long, Double>comparingByValue().reversed())
                .limit(topN)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        // 如果推荐数量不足，用热门商品补齐
        if (recommendedIds.size() < topN) {
            List<Product> popular = getPopularProducts(allItems, topN);
            for (Product p : popular) {
                if (recommendedIds.size() >= topN) break;
                if (!recommendedIds.contains(p.getId()) && !targetUserProducts.contains(p.getId())) {
                    recommendedIds.add(p.getId());
                }
            }
        }

        if (recommendedIds.isEmpty()) {
            return Collections.emptyList();
        }

        // 5. 批量查询商品详情
        List<Product> products = productService.listByIds(recommendedIds);
        // 保持推荐顺序
        Map<Long, Product> productMap = products.stream()
                .collect(Collectors.toMap(Product::getId, p -> p, (a, b) -> a));
        return recommendedIds.stream()
                .map(productMap::get)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    /**
     * 获取热门商品（按被下单次数排序）
     */
    private List<Product> getPopularProducts(List<OrderItem> allItems, int topN) {
        Map<Long, Long> productOrderCount = allItems.stream()
                .collect(Collectors.groupingBy(OrderItem::getProductId, Collectors.counting()));

        List<Long> popularIds = productOrderCount.entrySet().stream()
                .sorted(Map.Entry.<Long, Long>comparingByValue().reversed())
                .limit(topN)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        if (popularIds.isEmpty()) {
            // 没有订单数据时，直接返回最新的几个商品
            return productService.list(new LambdaQueryWrapper<Product>()
                    .eq(Product::getStatus, 1)
                    .orderByDesc(Product::getId)
                    .last("limit " + topN));
        }

        return productService.listByIds(popularIds);
    }
}
