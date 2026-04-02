package com.sias.agri.controller;

import com.sias.agri.common.ApiResponse;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * AI 智能客服接口
 * <p>
 * 基于关键词匹配的智能问答系统，预设农产品产销对接领域的常见问题与解答。
 * 支持模糊匹配和多关键词命中，优先返回匹配度最高的回答。
 */
@RestController
@RequestMapping("/api/ai")
public class AiChatController {

    /** FAQ 知识库 */
    private static final List<FaqEntry> FAQ_LIST = new ArrayList<>();

    static {
        // 平台相关
        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("注册", "怎么注册", "如何注册", "创建账号"),
                "欢迎使用农产品产销对接平台！注册步骤如下：\n1. 点击首页右上角「注册」按钮\n2. 选择您的身份（采购方或生产方）\n3. 填写用户名和密码\n4. 注册成功后即可登录使用平台功能"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("登录", "怎么登录", "忘记密码"),
                "登录方式：在首页点击「登录」，输入用户名和密码即可。如忘记密码，请联系平台管理员重置。"));

        // 采购方相关
        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("怎么买", "如何采购", "下单", "怎么下单", "购买", "购物车"),
                "采购流程：\n1. 在「供需大厅」浏览供应信息\n2. 找到心仪商品后点击「加入购物车」\n3. 进入购物车确认数量和收货地址\n4. 点击「提交订单」完成下单\n5. 等待生产方确认并安排配送"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("求购", "发布求购", "怎么发布"),
                "发布求购：登录后点击导航栏「发布信息」，选择「求购」类型，填写所需商品、数量、期望价格等信息，提交后等待管理员审核通过即可在平台展示。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("收藏", "如何收藏", "关注"),
                "收藏功能：在供需大厅浏览商品时，点击商品卡片上的❤️图标即可收藏。已收藏的商品可在「个人中心」查看。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("订单", "查看订单", "订单状态", "物流"),
                "订单管理：登录后进入「我的订单」页面可查看所有订单的状态，包括待确认、已确认、配送中、已送达等。如有问题可通过站内消息联系生产方。"));

        // 生产方相关
        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("供应", "发布供应", "怎么卖", "出售"),
                "发布供应信息：\n1. 登录生产方账号\n2. 先在后台添加您的商品档案\n3. 点击「发布信息」选择「供给」类型\n4. 填写供应详情（数量、价格、产地等）\n5. 提交后等待审核通过即可展示"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("资质", "认证", "资质认证", "审核"),
                "资质认证：生产方可在后台提交营业执照、产地证明等资质材料，管理员审核通过后会在您的信息上展示认证标识，增强采购方信任度。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("库存", "库存管理"),
                "库存管理：在管理后台的「库存管理」模块可以实时更新您的商品库存数量和仓储位置，确保供应信息的准确性。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("溯源", "二维码", "追溯", "产地"),
                "商品溯源：本平台支持商品二维码溯源功能。生产方可为每批商品创建溯源批次记录（含产地、生产日期、农残检测等信息），系统自动生成溯源二维码，扫描即可查看完整信息链。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("配送", "物流", "运输", "发货"),
                "配送说明：生产方在管理后台的「日程管理」中可安排配送计划，设置配送路线和时间。平台支持路线规划展示，方便双方跟踪配送进度。"));

        // 售后相关
        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("退款", "售后", "退货", "投诉", "纠纷"),
                "售后处理：如商品存在质量问题，可在订单详情中发起售后申请。支持「仅退款」和「退货退款」两种方式，管理员将在审核后处理。"));

        // 通用
        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("联系", "客服", "电话", "人工"),
                "如需人工客服协助，您可以通过站内消息功能联系平台管理员，我们会尽快回复您的问题。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("推荐", "猜你喜欢", "个性化"),
                "个性化推荐：平台采用协同过滤算法，根据您的历史订单和浏览偏好，在首页「为您推荐」区域展示您可能感兴趣的商品。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("价格", "多少钱", "报价"),
                "商品价格：各供应信息均由生产方自行定价，部分商品标注「价格面议」。您可以通过站内消息直接与生产方洽谈价格。"));

        FAQ_LIST.add(new FaqEntry(
                Arrays.asList("安全", "食品安全"),
                "食品安全：平台要求生产方提交资质认证，并支持商品溯源功能，确保农产品从产地到餐桌的每个环节可追溯、可查验。"));
    }

    @PostMapping("/chat")
    public ApiResponse<?> chat(@RequestBody Map<String, String> body) {
        String question = body.getOrDefault("question", "").trim();
        if (question.isEmpty()) {
            return ApiResponse.ok(Map.of("answer", "您好！请问有什么可以帮助您的？"));
        }

        // 计算每个FAQ条目的匹配得分
        FaqEntry bestMatch = null;
        int bestScore = 0;

        for (FaqEntry entry : FAQ_LIST) {
            int score = 0;
            for (String keyword : entry.keywords) {
                if (question.contains(keyword)) {
                    score += keyword.length(); // 长关键词权重更高
                }
            }
            if (score > bestScore) {
                bestScore = score;
                bestMatch = entry;
            }
        }

        String answer;
        if (bestMatch != null && bestScore > 0) {
            answer = bestMatch.answer;
        } else {
            answer = "感谢您的提问！这个问题我暂时无法准确回答。建议您：\n"
                    + "1. 尝试用更简短的关键词描述问题（如「下单」「溯源」「退款」）\n"
                    + "2. 通过站内消息联系平台管理员获取人工帮助\n"
                    + "我可以回答关于注册登录、采购下单、供应发布、溯源查询、售后处理等方面的问题。";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("answer", answer);
        result.put("matched", bestScore > 0);
        return ApiResponse.ok(result);
    }

    /** FAQ 条目 */
    private static class FaqEntry {
        final List<String> keywords;
        final String answer;

        FaqEntry(List<String> keywords, String answer) {
            this.keywords = keywords;
            this.answer = answer;
        }
    }
}
