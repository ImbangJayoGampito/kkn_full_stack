import { useState } from 'react';
import {
    Box,
    VStack,
    HStack,
    Text,
    Heading,
    Input,
    InputField,
    InputIcon,
    InputSlot,
    Button,
    ButtonText,
    ButtonIcon,
    Badge,
    BadgeText,
    Card,
    Icon,
    FlatList,
    Dimensions,
} from '@gluestack-ui/themed';
import {
    SearchIcon,
    FilterIcon,
    ArrowLeftIcon,
    StarIcon,
} from 'lucide-react-native'; // or your lucide icons path
import { Image } from 'expo-image';

// Mock data (same as original)
const products = [
    {
        id: '1',
        name: 'Kerajinan Tangan Ukiran Kayu',
        category: 'Kerajinan',
        price: 'Rp 150.000',
        stock: 25,
        umkm: 'Kerajinan Tangan Minang',
        image: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400',
        rating: 4.8,
    },
    {
        id: '2',
        name: 'Rendang Daging Premium',
        category: 'Kuliner',
        price: 'Rp 85.000',
        stock: 50,
        umkm: 'Warung Rendang Asli',
        image: 'https://images.unsplash.com/photo-1625398407796-82650a8c135f?w=400',
        rating: 4.9,
    },
    // ... add remaining products here
];

const { width } = Dimensions.get('window');
const itemWidth = (width - 48) / 2; // 2 columns with padding/gap

interface ProductTablePageProps {
    onProductClick: (productId: string) => void;
    onBack: () => void;
}

export function ProductTablePage({ onProductClick, onBack }: ProductTablePageProps) {
    const [searchTerm, setSearchTerm] = useState('');
    const [categoryFilter, setCategoryFilter] = useState('all');

    const filteredProducts = products.filter((product) => {
        const matchesSearch =
            product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            product.umkm.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesCategory = categoryFilter === 'all' || product.category === categoryFilter;
        return matchesSearch && matchesCategory;
    });

    return (
        <Box flex={1} bg="$backgroundLight50" _dark={{ bg: '$backgroundDark950' }}>
            {/* Header / Sticky top bar */}
            <VStack
                bg="$white"
                borderBottomWidth={1}
                borderColor="$borderLight200"
                _dark={{ bg: '$backgroundDark800', borderColor: '$borderDark700' }}
                position="sticky"
                top={0}
                zIndex={10}
            >
                <VStack space="md" p="$4" maxWidth={1280} mx="auto" w="$full">
                    <Button
                        variant="link"
                        onPress={onBack}
                        alignSelf="flex-start"
                        p="$0"
                    >
                        <ButtonIcon as={ArrowLeftIcon} mr="$2" />
                        <ButtonText>Kembali</ButtonText>
                    </Button>

                    <Heading size="3xl">Produk UMKM</Heading>

                    {/* Search + Filter row */}
                    <HStack space="md" flexDirection={{ base: 'column', md: 'row' }}>
                        <Input flex={1} variant="outline" size="md">
                            <InputSlot pl="$3">
                                <InputIcon as={SearchIcon} color="$muted500" />
                            </InputSlot>
                            <InputField
                                placeholder="Cari produk atau UMKM..."
                                value={searchTerm}
                                onChangeText={setSearchTerm}
                            />
                        </Input>

                        <Box w={{ base: '$full', md: 200 }}>
                            <Select
                                selectedValue={categoryFilter}
                                onValueChange={setCategoryFilter}
                            >
                                <SelectTrigger variant="outline" size="md">
                                    <SelectInput placeholder="Kategori" />
                                    <SelectIcon mr="$3" as={FilterIcon} />
                                </SelectTrigger>
                                <SelectPortal>
                                    <SelectBackdrop />
                                    <SelectContent>
                                        <SelectItem label="Semua Kategori" value="all" />
                                        <SelectItem label="Kerajinan" value="Kerajinan" />
                                        <SelectItem label="Kuliner" value="Kuliner" />
                                        <SelectItem label="Fashion" value="Fashion" />
                                        <SelectItem label="F&B" value="F&B" />
                                    </SelectContent>
                                </SelectPortal>
                            </Select>
                        </Box>
                    </HStack>
                </VStack>
            </VStack>

            {/* Main content */}
            <Box flex={1} p="$6" maxWidth={1280} mx="auto" w="$full">
                {filteredProducts.length === 0 ? (
                    <Box flex={1} justifyContent="center" alignItems="center" py="$12">
                        <Text color="$muted500" size="lg">
                            Tidak ada produk ditemukan
                        </Text>
                    </Box>
                ) : (
                    <FlatList
                        data={filteredProducts}
                        numColumns={2}
                        columnWrapperStyle={{ justifyContent: 'space-between', gap: 16 }}
                        contentContainerStyle={{ paddingBottom: 24 }}
                        renderItem={({ item }) => (
                            <Card
                                w={itemWidth}
                                mb="$6"
                                shadowColor="$trueGray200"
                                shadowOffset={{ width: 0, height: 2 }}
                                shadowOpacity={0.1}
                                shadowRadius={4}
                                onPress={() => onProductClick(item.id)}
                                borderRadius="$xl"
                                overflow="hidden"
                                hover={{ shadowColor: '$trueGray300', shadowRadius: 8 }}
                            >
                                <Box position="relative" aspectRatio={1}>
                                    <Image
                                        source={{ uri: item.image }}
                                        style={{ width: '100%', height: '100%' }}
                                        contentFit="cover"
                                        transition={200}
                                    />
                                    <Badge
                                        position="absolute"
                                        top="$2"
                                        right="$2"
                                        variant="solid"
                                        bg="$trueGray800"
                                        _text={{ color: '$white' }}
                                    >
                                        <BadgeText>{item.category}</BadgeText>
                                    </Badge>
                                </Box>

                                <VStack space="xs" p="$4">
                                    <Text
                                        fontWeight="$semibold"
                                        size="lg"
                                        numberOfLines={2}
                                        ellipsizeMode="tail"
                                    >
                                        {item.name}
                                    </Text>
                                    <Text size="sm" color="$muted500">
                                        {item.umkm}
                                    </Text>

                                    <HStack justifyContent="space-between" alignItems="center" mt="$1">
                                        <Text fontWeight="$bold" size="xl" color="$primary600">
                                            {item.price}
                                        </Text>
                                        <HStack space="xs" alignItems="center">
                                            <Icon as={StarIcon} color="$yellow500" fill="$yellow500" size="sm" />
                                            <Text fontWeight="$medium">{item.rating}</Text>
                                        </HStack>
                                    </HStack>

                                    <Text size="sm" color="$muted500">
                                        Stok: {item.stock} unit
                                    </Text>
                                </VStack>
                            </Card>
                        )}
                        keyExtractor={(item) => item.id}
                    />
                )}
            </Box>
        </Box>
    );
}