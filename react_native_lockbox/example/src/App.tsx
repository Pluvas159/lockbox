import { useState } from 'react';
import {
  Text,
  View,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  ScrollView,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import {
  saveSecureString,
  getSecureString,
  deleteSecureString,
} from 'react_native_lockbox';

export default function App() {
  const [key, setKey] = useState('');
  const [value, setValue] = useState('');
  const [status, setStatus] = useState<string | null>(null);
  const [result, setResult] = useState<string | null>(null);

  const handleSave = async () => {
    if (!key.trim()) {
      setStatus('Error: Key is required');
      return;
    }
    try {
      const success = await saveSecureString(key, value);
      setStatus(success ? 'Success: Saved string!' : 'Failed: Could not save string');
      setResult(null);
    } catch (err: any) {
      setStatus(`Exception: ${err.message}`);
    }
  };

  const handleGet = async () => {
    if (!key.trim()) {
      setStatus('Error: Key is required');
      return;
    }
    try {
      const val = await getSecureString(key);
      if (val === null) {
        setStatus('Not Found: No value for this key');
        setResult(null);
      } else {
        setStatus('Success: Retrieved value!');
        setResult(val);
      }
    } catch (err: any) {
      setStatus(`Exception: ${err.message}`);
    }
  };

  const handleDelete = async () => {
    if (!key.trim()) {
      setStatus('Error: Key is required');
      return;
    }
    try {
      const success = await deleteSecureString(key);
      setStatus(success ? 'Success: Deleted key!' : 'Failed: Could not delete');
      setResult(null);
    } catch (err: any) {
      setStatus(`Exception: ${err.message}`);
    }
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar barStyle="light-content" />
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={styles.keyboardView}
      >
        <ScrollView contentContainerStyle={styles.scrollContainer}>
          <View style={styles.header}>
            <Text style={styles.headerSubtitle}>REACT NATIVE SDK</Text>
            <Text style={styles.headerTitle}>Lockbox Secure Storage</Text>
          </View>

          <View style={styles.card}>
            <Text style={styles.cardTitle}>Credentials Manager</Text>

            <Text style={styles.label}>Storage Key</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g. user_token"
              placeholderTextColor="#5a5a65"
              value={key}
              onChangeText={setKey}
              autoCapitalize="none"
              autoCorrect={false}
            />

            <Text style={styles.label}>Secure Value (for save)</Text>
            <TextInput
              style={[styles.input, styles.valueInput]}
              placeholder="e.g. s3cr3t_p@ssw0rd!"
              placeholderTextColor="#5a5a65"
              value={value}
              onChangeText={setValue}
              autoCapitalize="none"
              autoCorrect={false}
              multiline
            />

            <View style={styles.buttonGroup}>
              <TouchableOpacity style={[styles.button, styles.saveButton]} onPress={handleSave}>
                <Text style={styles.buttonText}>Save</Text>
              </TouchableOpacity>

              <TouchableOpacity style={[styles.button, styles.getButton]} onPress={handleGet}>
                <Text style={styles.buttonText}>Retrieve</Text>
              </TouchableOpacity>

              <TouchableOpacity style={[styles.button, styles.deleteButton]} onPress={handleDelete}>
                <Text style={styles.buttonText}>Delete</Text>
              </TouchableOpacity>
            </View>
          </View>

          {(status || result !== null) && (
            <View style={styles.card}>
              <Text style={styles.cardTitle}>Operation Result</Text>
              
              {status && (
                <View style={styles.resultRow}>
                  <Text style={styles.resultLabel}>Status:</Text>
                  <Text style={[styles.resultValue, status.startsWith('Success') ? styles.textSuccess : styles.textAlert]}>
                    {status}
                  </Text>
                </View>
              )}

              {result !== null && (
                <View style={[styles.resultRow, styles.valueRow]}>
                  <Text style={styles.resultLabel}>Retrieved Value:</Text>
                  <Text style={styles.retrievedText}>{result}</Text>
                </View>
              )}
            </View>
          )}
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#0c0c0e',
  },
  keyboardView: {
    flex: 1,
  },
  scrollContainer: {
    padding: 24,
    flexGrow: 1,
    justifyContent: 'center',
  },
  header: {
    marginBottom: 32,
    alignItems: 'center',
  },
  headerSubtitle: {
    color: '#6366f1',
    fontSize: 12,
    fontWeight: '700',
    letterSpacing: 2,
    marginBottom: 6,
  },
  headerTitle: {
    color: '#ffffff',
    fontSize: 28,
    fontWeight: '800',
    letterSpacing: -0.5,
  },
  card: {
    backgroundColor: '#16161a',
    borderRadius: 16,
    padding: 24,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: '#24242b',
    shadowColor: '#000000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 12,
    elevation: 8,
  },
  cardTitle: {
    color: '#ffffff',
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#24242b',
    paddingBottom: 10,
  },
  label: {
    color: '#a1a1aa',
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 8,
  },
  input: {
    backgroundColor: '#1f1f24',
    borderColor: '#2d2d34',
    borderWidth: 1,
    borderRadius: 8,
    padding: 12,
    color: '#ffffff',
    fontSize: 16,
    marginBottom: 20,
  },
  valueInput: {
    height: 80,
    textAlignVertical: 'top',
  },
  buttonGroup: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 10,
  },
  button: {
    flex: 1,
    paddingVertical: 14,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 3,
  },
  saveButton: {
    backgroundColor: '#4f46e5',
  },
  getButton: {
    backgroundColor: '#059669',
  },
  deleteButton: {
    backgroundColor: '#dc2626',
  },
  buttonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '700',
  },
  resultRow: {
    flexDirection: 'row',
    marginBottom: 10,
    flexWrap: 'wrap',
  },
  resultLabel: {
    color: '#a1a1aa',
    fontSize: 14,
    fontWeight: '600',
    marginRight: 6,
  },
  resultValue: {
    fontSize: 14,
    fontWeight: '700',
  },
  textSuccess: {
    color: '#34d399',
  },
  textAlert: {
    color: '#f87171',
  },
  valueRow: {
    flexDirection: 'column',
    marginTop: 10,
  },
  retrievedText: {
    backgroundColor: '#1f1f24',
    borderRadius: 8,
    padding: 16,
    color: '#ffffff',
    fontFamily: Platform.OS === 'ios' ? 'Courier' : 'monospace',
    fontSize: 15,
    borderWidth: 1,
    borderColor: '#2d2d34',
    marginTop: 8,
  },
});
