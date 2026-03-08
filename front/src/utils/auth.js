const TOKEN_KEY = 'agri_token'
const USER_KEY = 'agri_user'

const notifyAuthChange = () => {
  window.dispatchEvent(new Event('auth-change'))
}

export const setAuth = (token, user) => {
  localStorage.setItem(TOKEN_KEY, token)
  localStorage.setItem(USER_KEY, JSON.stringify(user))
  notifyAuthChange()
}

export const clearAuth = () => {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(USER_KEY)
  notifyAuthChange()
}

export const getToken = () => localStorage.getItem(TOKEN_KEY)

export const getUser = () => {
  const raw = localStorage.getItem(USER_KEY)
  if (!raw) return null
  try {
    return JSON.parse(raw)
  } catch {
    return null
  }
}

export const isLoggedIn = () => Boolean(getToken())
