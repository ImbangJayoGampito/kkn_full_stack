// A successful result
export interface Ok<T, E> {
  readonly ok: true;
  readonly value: T;
}

// An error result
export interface Err<T, E> {
  readonly ok: false;
  readonly error: E;
}

// Result<T, E> is either Ok or Err
export type Result<T, E> = Ok<T, E> | Err<T, E>;
export function Ok<T, E = never>(value: T): Result<T, E> {
  return { ok: true, value };
}

export function Err<T = never, E = unknown>(error: E): Result<T, E> {
  return { ok: false, error };
}

export async function tryFail<T>(
  f: (() => Promise<T>) | (() => T),
): Promise<Result<T, Error>> {
  try {
    const result = await Promise.resolve(f());
    return await Ok(result);
  } catch (e) {
    return Err(new Error("Error because of: " + e));
  }
}
