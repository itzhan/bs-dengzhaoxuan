import request from '@/utils/http'

/**
 * 登录
 * @param params 登录参数
 * @returns 登录响应
 */
export function fetchLogin(params: Api.Auth.LoginParams) {
  return request.post<Api.Auth.LoginResponse>({
    url: '/api/auth/login',
    params
    // showSuccessMessage: true // 显示成功消息
    // showErrorMessage: false // 不显示错误消息
  })
}

/**
 * 获取用户信息
 * @returns 用户信息
 */
export function fetchGetUserInfo() {
  return request
    .get<any>({
      url: '/api/auth/me'
    })
    .then((data) => {
      const role = String(data?.role || '').toUpperCase()
      const roleMap: Record<string, string> = {
        ADMIN: 'R_ADMIN',
        PRODUCER: 'R_PRODUCER',
        BUYER: 'R_BUYER'
      }
      return {
        userId: data?.id,
        userName: data?.username,
        roles: [roleMap[role] || 'R_BUYER'],
        buttons: [],
        email: '',
        avatar: data?.avatar
      } as Api.Auth.UserInfo
    })
}

/**
 * 注册
 */
export function fetchRegister(params: {
  username: string
  password: string
  role: number
  realName?: string
  gender?: number
  address?: string
  avatar?: string
}) {
  return request.post<void>({
    url: '/api/auth/register',
    params
  })
}
