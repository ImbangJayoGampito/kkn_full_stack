// models/ProductImage.ts
export interface ProductImage {
  id: number;
  url: string;
  alt: string;
  title: string;
}

export function productImageFromJson(json: any): ProductImage {
  return {
    id: json.id,
    url: json.url,
    alt: json.alt ?? "",
    title: json.title ?? "",
  };
}
