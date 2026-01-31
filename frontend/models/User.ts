import * as SecureStore from "expo-secure-store";
// adjust based on your alias
import { AppConfig } from "@/config/AppConfig"; // your config file
import { Result, Err, Ok } from "@/utils/result";

export interface User {
  id: number;
  username: string;
  email: string;
}

export function userFromJson(json: any): User {
  return {
    id: json.id as number,
    username: json.username as string,
    email: json.email as string,
  };
}

export class UserAPI {
  // SecureStore keys use Expo SecureStore backed by OS keychain/keystore. :contentReference[oaicite:0]{index=0}

  static async loginUser(args: {
    username: string;
    password: string;
    endpoint: string;
    timeoutMs?: number;
  }): Promise<Result<User, string>> {
    const {
      username,
      password,
      endpoint,
      timeoutMs = AppConfig.requestTimeoutMs,
    } = args;

    try {
      const res = await Promise.race([
        fetch(endpoint, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          body: JSON.stringify({ username, password }),
        }),
        new Promise<never>((_, reject) =>
          setTimeout(() => reject(new Error("Timeout")), timeoutMs),
        ),
      ]);

      const response = res as Response;

      const text = await response.text();
      let data: any;
      try {
        data = JSON.parse(text);
      } catch {
        return Err<User, string>(
          "Login failed: invalid JSON returned from server",
        );
      }

      if (response.status === 200 && data.token) {
        await SecureStore.setItemAsync(AppConfig.sessionToken, data.token); // uses secure storage :contentReference[oaicite:1]{index=1}
      } else {
        return Err<User, string>(`Login failed: ${response.status} ${text}`);
      }

      const user = userFromJson(data.user);
      return Ok(user);
    } catch (e: any) {
      return Err<User, string>(e.message ?? "Unknown login error");
    }
  }

  static async registerUser(args: {
    username: string;
    password: string;
    email: string;
    endpoint: string;
    timeoutMs?: number;
  }): Promise<Result<User, string>> {
    const {
      username,
      password,
      email,
      endpoint,
      timeoutMs = AppConfig.requestTimeoutMs,
    } = args;

    try {
      const res = await Promise.race([
        fetch(endpoint, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          body: JSON.stringify({ username, password, email }),
        }),
        new Promise<never>((_, reject) =>
          setTimeout(() => reject(new Error("Timeout")), timeoutMs),
        ),
      ]);

      const response = res as Response;

      const text = await response.text();
      let data: any;
      try {
        data = JSON.parse(text);
      } catch {
        return Err<User, string>("Register failed: invalid JSON");
      }

      if ((response.status === 201 || response.status === 200) && data.token) {
        await SecureStore.setItemAsync(AppConfig.sessionToken, data.token);
      } else {
        return Err<User, string>(`Register failed: ${response.status} ${text}`);
      }

      return Ok(userFromJson(data.user));
    } catch (e: any) {
      return Err<User, string>(e.message ?? "Unknown register error");
    }
  }

  static async getToken(): Promise<string | null> {
    return SecureStore.getItemAsync(AppConfig.sessionToken);
  }

  static async logout(): Promise<boolean> {
    try {
      await SecureStore.deleteItemAsync(AppConfig.sessionToken);
      return true;
    } catch {
      return false;
    }
  }

  static async restoreFromSession(args: {
    token: string;
    endpoint: string;
    timeoutMs?: number;
  }): Promise<Result<User, string>> {
    const { token, endpoint, timeoutMs = AppConfig.requestTimeoutMs } = args;

    try {
      const res = await Promise.race([
        fetch(endpoint, {
          method: "POST",
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            Accept: "application/json",
          },
        }),
        new Promise<never>((_, reject) =>
          setTimeout(() => reject(new Error("Timeout")), timeoutMs),
        ),
      ]);

      const response = res as Response;
      const text = await response.text();

      let data: any;
      try {
        data = JSON.parse(text);
      } catch {
        return Err<User, string>(
          "Server returned HTML instead of JSON. Possible invalid token.",
        );
      }

      if (!response.ok) {
        return Err<User, string>(`Restore failed: ${response.status} ${text}`);
      }

      return Ok(userFromJson(data.user));
    } catch (e: any) {
      return Err<User, string>(
        `Restore failed: ${e.message ?? "unknown error"}`,
      );
    }
  }
}
