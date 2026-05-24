import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  saveSecureString(key: string, value: string): Promise<boolean>;
  getSecureString(key: string): Promise<string | null>;
  deleteSecureString(key: string): Promise<boolean>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ReactNativeLockbox');
