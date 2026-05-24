export function saveSecureString(_key: string, _value: string): Promise<boolean> {
  return Promise.reject(
    new Error("'react_native_lockbox' is only supported on native platforms.")
  );
}

export function getSecureString(_key: string): Promise<string | null> {
  return Promise.reject(
    new Error("'react_native_lockbox' is only supported on native platforms.")
  );
}

export function deleteSecureString(_key: string): Promise<boolean> {
  return Promise.reject(
    new Error("'react_native_lockbox' is only supported on native platforms.")
  );
}
