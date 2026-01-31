export const AppConfig = {
  apiUrl: "http://localhost:5094/api",
  sessionToken: "api-token" as const,
  requestTimeoutMs: 10000,
  get productsEndpoint() {
    return `${this.apiUrl}/product/`;
  },
  get loginEndpoint() {
    return `${this.apiUrl}/auth/login`;
  },
  get registerEndpoint() {
    return `${this.apiUrl}/auth/register`;
  },
  get userRestoreEndpoint() {
    return `${this.apiUrl}/auth/restore`;
  },
  get adminDashboardEndpoint() {
    return `${this.apiUrl}/admin/dashboard`;
  },
} as const;

export const RouteConfig = {
  mainMenu: "/",
  settings: "/settings",
  tourism: "/tourism",
  register: "/register",
  products: "/products",
  login: "/login",
} as const;
