import { Result, Ok, Err } from "@/utils/result"; // your Result type
export interface PaginatedResponse<T> {
  currentPage: number;
  pageSize: number;
  totalItems: number;
  totalPages: number;
  data: T[];
}

export function paginatedResponseFromJson<T>(
  json: any,
  fromJsonT: (item: any) => T,
): PaginatedResponse<T> {
  return {
    currentPage: json.currentPage,
    pageSize: json.pageSize,
    totalItems: json.totalItems,
    totalPages: json.totalPages,
    data: Array.isArray(json.data) ? json.data.map(fromJsonT) : [],
  };
}

export async function fetchPaginated<T>(args: {
  endpoint: string;
  token?: string;
  timeoutMs?: number;
  queryParams?: Record<string, string | number>;
  fromJsonT: (item: any) => T;
}): Promise<Result<PaginatedResponse<T>, string>> {
  const { endpoint, token, timeoutMs = 10000, queryParams, fromJsonT } = args;

  try {
    // build URL with query params, if any
    const url = new URL(endpoint);
    if (queryParams) {
      Object.entries(queryParams).forEach(([key, value]) => {
        url.searchParams.append(key, String(value));
      });
    }

    const response = (await Promise.race([
      fetch(url.toString(), {
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
        },
      }),
      new Promise<never>((_, reject) =>
        setTimeout(() => reject(new Error("Request timed out")), timeoutMs),
      ),
    ])) as Response;

    const text = await response.text();
    // check for non‑JSON errors (e.g., HTML error pages)
    if (text.trim().startsWith("<!DOCTYPE html>")) {
      return Err(
        "Server returned HTML instead of JSON — possible invalid token.",
      );
    }

    const data = JSON.parse(text);
    const paginated = paginatedResponseFromJson(data, fromJsonT);
    return Ok(paginated);
  } catch (e: any) {
    return Err(e.message ?? "Unknown error");
  }
}
