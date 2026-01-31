// services/productService.ts
import { Product, productFromJson } from "@/models/Product";
import { Result, Ok, Err } from "@/utils/result";
import { AppConfig } from "@/config/AppConfig";

export async function fetchProducts(args: {
  endpoint: string;
  token: string;
  timeoutMs?: number;
}): Promise<Result<Product[], string>> {
  const { endpoint, token, timeoutMs = AppConfig.requestTimeoutMs } = args;

  try {
    const response = (await Promise.race([
      fetch(endpoint, {
        method: "GET",
        headers: {
          Authorization: `Bearer ${token}`,
          Accept: "application/json",
          "Content-Type": "application/json",
        },
      }),
      new Promise<never>((_, reject) =>
        setTimeout(() => reject(new Error("Request timed out")), timeoutMs),
      ),
    ])) as Response;

    const text = await response.text();
    // HTML fallback detection (similar to your Dart logic)
    if (text.trim().startsWith("<!DOCTYPE html>")) {
      return Err(
        "Server returned HTML instead of JSON — possible invalid token.",
      );
    }

    let data: any;
    try {
      data = JSON.parse(text);
    } catch {
      return Err("Invalid JSON in response");
    }

    // If your API wraps products in `data`, adapt as needed
    const rawProducts = Array.isArray(data.data) ? data.data : [];
    const products: Product[] = rawProducts.map((item: any) =>
      productFromJson(item),
    );

    return Ok(products);
  } catch (e: any) {
    return Err(e.message ?? "Unknown fetch error");
  }
}
