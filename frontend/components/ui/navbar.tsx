import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, GestureResponderEvent } from 'react-native';
import { ColorblindSafePalette } from '@/config/AppConfig';
interface CustomNavbarProps {
    title: string;
    onLeftPress: (event: GestureResponderEvent) => void;  // Handle left button press
    onRightPress: (event: GestureResponderEvent) => void; // Handle right button press
}
const CustomNavbar: React.FC<CustomNavbarProps> = ({ title, onLeftPress, onRightPress }) => {
    return (
        <View style={styles.navbar}>
            {/* Left button */}
            <TouchableOpacity onPress={onLeftPress} style={styles.button}>
                <Text style={styles.buttonText}>{"<"}</Text>
            </TouchableOpacity>

            {/* Title */}
            <Text style={styles.title}>{title}</Text>

            {/* Right button */}
            <TouchableOpacity onPress={onRightPress} style={styles.button}>
                <Text style={styles.buttonText}>{"☰"}</Text> {/* You can replace with an icon or text */}
            </TouchableOpacity>
        </View>
    );
};

const styles = StyleSheet.create({
    navbar: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: 10,
        backgroundColor: ColorblindSafePalette.primary,
        height: 60,
    },
    button: {
        padding: 10,
    },
    buttonText: {
        fontSize: 20,
        color: 'white',
    },
    title: {
        fontSize: 20,
        color: 'white',
        fontWeight: 'bold',
    },
});

export default CustomNavbar;