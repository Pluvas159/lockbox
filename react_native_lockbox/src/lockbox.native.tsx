import ReactNativeLockbox from './NativeReactNativeLockbox';

export function saveSecureString(key: string, value: string): Promise<boolean> {
  return ReactNativeLockbox.saveSecureString(key, value);
}

export function getSecureString(key: string): Promise<string | null> {
  return ReactNativeLockbox.getSecureString(key);
}

export function deleteSecureString(key: string): Promise<boolean> {
  return ReactNativeLockbox.deleteSecureString(key);
}
