export const AppConfig = {
  apiUrl: "http://localhost:5094/api",
  sessionToken: "api-token" as const,
  requestTimeoutMs: 10000,
  get productsEndpoint() {
    return `${this.apiUrl}/produk`;  // Updated the endpoint to '/produk'
  },
  get loginEndpoint() {
    return `${this.apiUrl}/auth/login`;
  },
  get registerEndpoint() {
    return `${this.apiUrl}/auth/register`;
  },
  get userProfileEndpoint() {
    return `${this.apiUrl}/auth/profile`;  // Changed to use 'profile' endpoint
  },
  get logoutEndpoint() {
    return `${this.apiUrl}/auth/logout`;  // Added the logout endpoint
  },
  get adminDashboardEndpoint() {
    return `${this.apiUrl}/admin/dashboard`;
  },
  get walikorongEndpoint() {
    return `${this.apiUrl}/walikorong`;  // Endpoint for Walikorong
  },
  get walinagariEndpoint() {
    return `${this.apiUrl}/walinagari`;  // Endpoint for Walinagari
  },
} as const;

export const RouteConfig = {
  mainMenu: "/",  // Home or Dashboard route
  settings: "/settings",
  tourism: "/tourism",
  register: "/register",
  login: "/login",
  profile: "/profile",  // Added profile route
  products: "/products",  // Changed to '/products' to match the products API
  adminDashboard: "/admin/dashboard",  // Admin dashboard route
  walikorong: "/walikorong",  // Walikorong management route
  walinagari: "/walinagari",  // Walinagari management route

  // Product CRUD Routes
  createProduct: "/products/create",  // Route for creating a new product
  updateProduct: (id: string) => `/products/${id}/edit`,  // Route for updating a specific product
  deleteProduct: (id: string) => `/products/${id}/delete`,  // Route for deleting a specific product
  viewProduct: (id: string) => `/products/${id}`,  // Route for viewing a specific product

  // UMKM (Business) CRUD Routes
  createUmkm: "/umkm/create",  // Route for creating a new UMKM
  updateUmkm: (id: string) => `/umkm/${id}/edit`,  // Route for updating a specific UMKM
  deleteUmkm: (id: string) => `/umkm/${id}/delete`,  // Route for deleting a specific UMKM
  viewUmkm: (id: string) => `/umkm/${id}`,  // Route for viewing a specific UMKM

  // Walikorong CRUD Routes
  createWalikorong: "/walikorong/create",  // Route for creating a new Walikorong
  updateWalikorong: (id: string) => `/walikorong/${id}/edit`,  // Route for updating a specific Walikorong
  deleteWalikorong: (id: string) => `/walikorong/${id}/delete`,  // Route for deleting a specific Walikorong
  viewWalikorong: (id: string) => `/walikorong/${id}`,  // Route for viewing a specific Walikorong

  // Walinagari CRUD Routes
  createWalinagari: "/walinagari/create",  // Route for creating a new Walinagari
  updateWalinagari: (id: string) => `/walinagari/${id}/edit`,  // Route for updating a specific Walinagari
  deleteWalinagari: (id: string) => `/walinagari/${id}/delete`,  // Route for deleting a specific Walinagari
  viewWalinagari: (id: string) => `/walinagari/${id}`,  // Route for viewing a specific Walinagari
} as const;

export const ColorblindSafePalette = {
  primary: '#0072B2',   // Strong blue
  secondary: '#999999', // Medium gray
  success: '#009E73',   // Teal green
  danger: '#D55E00',    // Orange-red
  warning: '#E69F00',   // Amber
  info: '#56B4E9',      // Sky blue
  light: '#F0F0F0',     // Soft gray
  dark: '#333333',      // Deep gray
  white: '#FFFFFF',
  black: '#000000',
};
