import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons'; // Use Expo vector icons

interface LoginPageProps {
    onLogin: (username: string, password: string) => void;
    onNavigateToRegister: () => void;
}

export function LoginPage({ onLogin, onNavigateToRegister }: LoginPageProps) {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState<string | null>(null); // State for error message

    const handleSubmit = () => {
        // Basic validation check
        if (!username || !password) {
            setError('Username and Password are required.');
            return;
        }
        setError(null); // Clear error if validation passes
        onLogin(username, password);
    };

    return (
        <View style={styles.container}>
            <View style={styles.card}>
                <View style={styles.header}>
                    <View style={styles.iconContainer}>
                        <Ionicons name="log-in-outline" size={32} color="white" />
                    </View>
                    <Text style={styles.title}>Selamat Datang</Text>
                    <Text style={styles.description}>Masuk ke akun Anda untuk melanjutkan</Text>
                </View>

                <View style={styles.form}>
                    <View style={styles.inputGroup}>
                        <Text style={styles.label}>Username</Text>
                        <TextInput
                            style={styles.input}
                            placeholder="Masukkan username"
                            value={username}
                            onChangeText={setUsername} // Update state
                        />
                    </View>

                    <View style={styles.inputGroup}>
                        <Text style={styles.label}>Password</Text>
                        <TextInput
                            style={styles.input}
                            placeholder="Masukkan password"
                            secureTextEntry
                            value={password}
                            onChangeText={setPassword} // Update state
                        />
                    </View>

                    {error && <Text style={styles.errorText}>{error}</Text>} {/* Error message display */}
                </View>

                <View style={styles.footer}>
                    <TouchableOpacity onPress={handleSubmit} style={styles.button}>
                        <Text style={styles.buttonText}>Masuk</Text>
                    </TouchableOpacity>
                    <Text style={styles.registerText}>
                        Belum punya akun?{' '}
                        <TouchableOpacity onPress={onNavigateToRegister}>
                            <Text style={styles.registerLink}>Daftar di sini</Text>
                        </TouchableOpacity>
                    </Text>
                </View>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f0f4ff', // Gradient is harder to achieve, you can use a solid color or use libraries for gradient
        padding: 16,
    },
    card: {
        width: '100%',
        maxWidth: 400,
        backgroundColor: 'white',
        borderRadius: 12,
        padding: 20,
        shadowColor: '#000',
        shadowOpacity: 0.1,
        shadowRadius: 10,
        elevation: 5,
    },
    header: {
        alignItems: 'center',
        marginBottom: 20,
    },
    iconContainer: {
        backgroundColor: '#6366f1',
        padding: 16,
        borderRadius: 50,
        marginBottom: 16,
    },
    title: {
        fontSize: 24,
        fontWeight: '600',
        textAlign: 'center',
    },
    description: {
        fontSize: 14,
        color: '#6b7280',
        textAlign: 'center',
    },
    form: {
        marginBottom: 20,
    },
    inputGroup: {
        marginBottom: 16,
    },
    label: {
        fontSize: 14,
        color: '#374151',
        marginBottom: 4,
    },
    input: {
        height: 40,
        borderColor: '#ddd',
        borderWidth: 1,
        borderRadius: 8,
        paddingLeft: 12,
        fontSize: 16,
    },
    footer: {
        flexDirection: 'column',
        alignItems: 'center',
    },
    button: {
        backgroundColor: '#6366f1',
        paddingVertical: 12,
        paddingHorizontal: 16,
        borderRadius: 8,
        width: '100%',
        alignItems: 'center',
        marginBottom: 12,
    },
    buttonText: {
        color: 'white',
        fontSize: 16,
        fontWeight: '500',
    },
    registerText: {
        fontSize: 14,
        color: '#6b7280',
        textAlign: 'center',
    },
    registerLink: {
        color: '#6366f1',
        textDecorationLine: 'underline',
    },
    errorText: {
        color: 'red',
        fontSize: 12,
        textAlign: 'center',
        marginBottom: 12,
    },
});
