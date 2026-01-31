import { productImageFromJson, ProductImage } from "./ProductImage";

export interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  stock: number;
  imageUrl?: string | null;
  images: ProductImage[];
}

export function productFromJson(json: any): Product {
  return {
    id: json.id,
    name: json.name,
    description: json.description,
    price: Number(json.price ?? 0),
    stock: json.stock ?? 0,
    imageUrl: json.imageUrl ?? null,
    images: Array.isArray(json.images)
      ? json.images.map(productImageFromJson)
      : [],
  };
}
