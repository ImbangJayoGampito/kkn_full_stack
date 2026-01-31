import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import 'react-native-reanimated';
import CustomNavbar from '@/components/ui/navbar';
import { useColorScheme } from '@/hooks/use-color-scheme';
import { useNavigation } from '@react-navigation/native';
export const unstable_settings = {
  anchor: '(tabs)',
};

export default function RootLayout() {
  const colorScheme = useColorScheme();
  const navigation = useNavigation();
  return (
    <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
      <Stack>
        {/* Tabs screen */}
        <Stack.Screen name="(tabs)" options={{ header: () => <CustomNavbar title="Tabs" onLeftPress={() => { navigation.goBack(); }} onRightPress={() => { }} /> }} />

        {/* Modal screen */}

      </Stack>
      <StatusBar style="auto" />
    </ThemeProvider>
  );
}