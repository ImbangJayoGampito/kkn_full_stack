import React from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, StyleSheet, Alert, Dimensions } from 'react-native';
import { Ionicons } from '@expo/vector-icons'; // Expo vector icons
import Carousel from 'react-native-snap-carousel';
import { ColorblindSafePalette } from '@/config/AppConfig'
const styles = StyleSheet.create({
  imageWrapper: {
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
  },
  image: {
    width: 150,
    height: 150,
  },
  textWrapper: {
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 5,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  description: {
    fontSize: 16,
    color: ColorblindSafePalette.black,
    textAlign: 'center',
    fontWeight: '800'
  },

  // New styles for facilities section
  facilitiesContainer: {
    marginHorizontal: 10,
    marginVertical: 20,
  },
  facilitiesTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  facilityItem: {
    flexDirection: 'row',
    marginVertical: 5,
    padding: 10,
    backgroundColor: '#fff',
    borderRadius: 8,
    alignItems: 'center',
  },
  facilityIcon: {
    fontSize: 24,
    marginRight: 10,
  },
  facilityName: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  facilityCount: {
    fontSize: 14,
    color: '#888',
  },

  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  header: {
    backgroundColor: ColorblindSafePalette.primary,
    padding: 20,
    borderBottomLeftRadius: 20,
    borderBottomRightRadius: 20,
  },
  headerContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
  },
  headerLocation: {
    color: 'white',
    marginTop: 5,
  },

  // Carousel Styles
  carouselContainer: {
    marginTop: 20,
  },
  carouselItem: {
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.1,
    shadowRadius: 6,
    elevation: 5,
  },
  carouselImage: {
    width: '100%',
    height: 250,
    borderRadius: 10,
  },
  carouselOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: 10,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  carouselTitle: {
    fontSize: 20,
    color: 'white',
    fontWeight: 'bold',
  },
  carouselDescription: {
    color: '#E0E0E0',
  },

  // Other card and list related styles
  cardsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: 20,
    marginHorizontal: 10,
  },
  card: {
    backgroundColor: 'white',
    padding: 15,
    borderRadius: 10,
    width: '22%',
    alignItems: 'center',
  },
  cardTitle: {
    color: '#555',
    fontSize: 12,
  },
  cardValue: {
    fontSize: 18,
    fontWeight: 'bold',
  },

  listContainer: {
    marginHorizontal: 10,
    marginBottom: 20,
  },
  listTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  listItem: {
    backgroundColor: 'white',
    padding: 15,
    borderRadius: 10,
    marginBottom: 10,
  },
  listItemTitle: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  listItemDetails: {
    fontSize: 14,
    color: '#666',
  },
  listItemRating: {
    fontSize: 14,
    color: '#f39c12',
  },
});
// Mock data (same as your web data)
const nagariData = {
  name: 'Nagari Toboh Gadang Timur',
  location: 'Sumatera Barat, Indonesia',
  description:
    'Nagari Toboh Gadang Timur adalah sebuah nagari pemekaran di Kecamatan Sintuk Toboh Gadang...',
  population: '12,450',
  area: '45.5 km²',
  korongCount: 4,
  umkmCount: 42,
};
const { width } = Dimensions.get('window');
const facilities = [
  { name: 'Sekolah', icon: '🏫', count: 3 },
  { name: 'Masjid', icon: '🕌', count: 1 },
  { name: 'Surau', icon: '🏪', count: 4 },
];

const korongList = [
  { id: '1', name: 'Korong Toboh Baru Toboh Gadang', population: '1,200', waliKorong: 'MAYUNIS' },
  { id: '2', name: 'Korong Toboh Tangah Padang', population: '980', waliKorong: 'KHAIRUL JANUAR RAMADANI, S.T.' },
  { id: '3', name: 'Korong Toboh Rimbo Kaduduak', population: '1,050', waliKorong: 'ZULKHAIRIL' },
  { id: '4', name: 'Korong Sawah Mansi', population: '890', waliKorong: 'SONI ARWAN, S.Kom.' },
];

const umkmList = [
  { id: '1', name: 'Kerajinan Tangan Minang', category: 'Kerajinan', rating: 4.8 },
  { id: '2', name: 'Warung Rendang Asli', category: 'Kuliner', rating: 4.9 },
  { id: '3', name: 'Tenun Tradisional', category: 'Fashion', rating: 4.7 },
  { id: '4', name: 'Kopi Robusta Lokal', category: 'F&B', rating: 4.6 },
];

// Type for each carousel slide
interface CarouselSlide {
  id: number;
  image: string;
  title: string;
  description: string;
}

const exampleSlides = [
  {
    id: '1',
    image: 'https://images.unsplash.com/photo-1671080749770-791e382d681c?fit=max&fm=jpg&w=1200',
    title: 'Selamat Datang di Nagari Toboh Gadang Timur',
    description: 'Menjelajahi keindahan dan kebudayaan Minangkabau yang autentik dan memesona.',
  },
  {
    id: '2',
    image: 'https://images.unsplash.com/photo-1653910729824-df4f32c60acf?fit=max&fm=jpg&w=1200',
    title: 'Rumah Gadang Tradisional',
    description: 'Simbol kebesaran keluarga Minang dengan atap gonjong yang ikonik dan megah.',
  },
  {
    id: '3',
    image: 'https://images.unsplash.com/photo-1609052614093-e5e48ddcaeab?fit=max&fm=jpg&w=1200',
    title: 'Sawah Terasering Nan Indah',
    description: 'Pemandangan sawah berundak yang hijau menyejukkan mata dan hati.',
  },
  {
    id: '4',
    image: 'https://images.unsplash.com/photo-1580130718646-9f694209b207?fit=max&fm=jpg&w=1200',
    title: 'Tari Piring Khas Minang',
    description: 'Tarian tradisional penuh semangat dengan gerakan lincah dan piring berputar.',
  },
];

const pagesData = exampleSlides.map((slide, index) => ({
  key: slide.id,
  components: [
    <View key={`img-${index}`} style={styles.imageWrapper}>
      <Image source={{ uri: slide.image }} style={styles.image} />
    </View>,
    <View key={`title-${index}`} style={styles.textWrapper}>
      <Text style={styles.title}>{slide.title}</Text>
    </View>,
    <View key={`desc-${index}`} style={styles.textWrapper}>
      <Text style={styles.description}>{slide.description}</Text>
    </View>,
  ],
}));
const renderItem = ({ item }: { item: any }) => (
  <View style={styles.container}>
    {/* Render the components for each page */}
    {item.components}
  </View>
);
export default function NagariMainPage({ onNavigateToKorong, onNavigateToUMKM }: { onNavigateToKorong: (korongId: string) => void; onNavigateToUMKM: (umkmId: string) => void; }) {

  const renderCarouselItem = ({ item }: any) => (
    <View style={styles.carouselItem}>
      <Image source={{ uri: item.image }} style={styles.carouselImage} />
      <View style={styles.carouselOverlay}>
        <Text style={styles.carouselTitle}>{item.title}</Text>
        <Text style={styles.carouselDescription}>{item.description}</Text>
      </View>
    </View>
  );

  return (
    <ScrollView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerContent}>
          <Ionicons name="location-sharp" size={32} color="white" />
          <View>
            <Text style={styles.headerTitle}>{nagariData.name}</Text>
            <Text style={styles.headerLocation}>{nagariData.location}</Text>
          </View>
        </View>
        <Text style={styles.description}>{nagariData.description}</Text>
      </View>

      {/* Image Carousel */}


      {/* Statistics Cards */}
      <View style={styles.cardsContainer}>
        <View style={styles.card}>
          <Ionicons name="people-sharp" size={32} color="indigo" />
          <Text style={styles.cardTitle}>Populasi</Text>
          <Text style={styles.cardValue}>{nagariData.population}</Text>
        </View>
        <View style={styles.card}>
          <Ionicons name="location-sharp" size={32} color="green" />
          <Text style={styles.cardTitle}>Luas Wilayah</Text>
          <Text style={styles.cardValue}>{nagariData.area}</Text>
        </View>
        <View style={styles.card}>
          <Ionicons name="home-sharp" size={32} color="blue" />
          <Text style={styles.cardTitle}>Jumlah Korong</Text>
          <Text style={styles.cardValue}>{nagariData.korongCount}</Text>
        </View>
        <View style={styles.card}>
          <Ionicons name="briefcase-sharp" size={32} color="purple" />
          <Text style={styles.cardTitle}>Jumlah UMKM</Text>
          <Text style={styles.cardValue}>{nagariData.umkmCount}</Text>
        </View>
      </View>

      {/* Facilities */}
      <View style={styles.facilitiesContainer}>
        <Text style={styles.facilitiesTitle}>Fasilitas Nagari</Text>
        {facilities.map((facility) => (
          <View key={facility.name} style={styles.facilityItem}>
            <Text style={styles.facilityIcon}>{facility.icon}</Text>
            <View>
              <Text style={styles.facilityName}>{facility.name}</Text>
              <Text style={styles.facilityCount}>{facility.count}</Text>
            </View>
          </View>
        ))}
      </View>

      {/* Korong List */}
      <View style={styles.listContainer}>
        <Text style={styles.listTitle}>Daftar Korong</Text>
        {korongList.map((korong) => (
          <TouchableOpacity
            key={korong.id}
            style={styles.listItem}
            onPress={() => onNavigateToKorong(korong.id)}
          >
            <Text style={styles.listItemTitle}>{korong.name}</Text>
            <Text style={styles.listItemDetails}>{korong.population} jiwa</Text>
            <Text style={styles.listItemDetails}>Wali Korong: {korong.waliKorong}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {/* UMKM List */}
      <View style={styles.listContainer}>
        <Text style={styles.listTitle}>UMKM Unggulan</Text>
        {umkmList.map((umkm) => (
          <TouchableOpacity
            key={umkm.id}
            style={styles.listItem}
            onPress={() => onNavigateToUMKM(umkm.id)}
          >
            <Text style={styles.listItemTitle}>{umkm.name}</Text>
            <Text style={styles.listItemDetails}>{umkm.category}</Text>
            <Text style={styles.listItemRating}>⭐ {umkm.rating}</Text>
          </TouchableOpacity>
        ))}
      </View>
    </ScrollView>
  );
}

