import { Provider } from 'app/provider'
import { Stack, Tabs } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { MaterialIcons } from '@expo/vector-icons'
import { Modal, ScrollView, TouchableOpacity } from 'react-native'
import { useState } from 'react'
import { P, SafeAreaView, View, H2 } from 'dripsy'
import { TextInput } from 'app/components/TextInput'

export default function Root() {
  const [addModalVisible, setAddModalVisible] = useState(false)
  return (
    <Provider>
      <StatusBar style="dark" />
      <Modal
        animationType="slide"
        visible={addModalVisible}
        onRequestClose={() => {
          setAddModalVisible(false)
        }}
      >
        <SafeAreaView
          sx={{
            flex: 1,
            m: 16,
          }}
        >
          <ScrollView>
            <H2>Create Shift</H2>
            <P>Name</P>
            <TextInput sx={{ mb: 3 }} />
            <P>Description</P>
            <TextInput sx={{ mb: 3 }} multiline numberOfLines={2} />
            <P>Start Date</P>
            <TextInput sx={{ mb: 3 }} />
            <P>End Date</P>
            <TextInput sx={{ mb: 3 }} />
          </ScrollView>
          <View
            sx={{
              position: 'absolute',
              bottom: 0,
              left: 0,
              width: '100%',
              p: 16,
              pb: 32,
              flexDirection: 'row',
              justifyContent: 'space-between',
            }}
          >
            <TouchableOpacity onPress={() => setAddModalVisible(false)}>
              <View
                sx={{
                  backgroundColor: 'red',
                  height: 35,
                  justifyContent: 'center',
                  alignItems: 'center',
                  borderRadius: 8,
                  width: 150,
                }}
              >
                <P sx={{ color: 'white' }}>Close</P>
              </View>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => setAddModalVisible(false)}>
              <View
                sx={{
                  backgroundColor: 'green',
                  height: 35,
                  justifyContent: 'center',
                  alignItems: 'center',
                  borderRadius: 8,
                  width: 150,
                }}
              >
                <P sx={{ color: 'white' }}>Create</P>
              </View>
            </TouchableOpacity>

          </View>
        </SafeAreaView>
      </Modal>
      <Tabs>
        <Tabs.Screen
          name="index"
          options={{
            title: 'Home',
            tabBarIcon: ({ color }) => (
              <MaterialIcons name="home" size={32} color={color} />
            ),
            tabBarLabel: () => null,
            headerRight: () => (
              <TouchableOpacity onPress={() => setAddModalVisible(true)}>
                <MaterialIcons name="add" size={32} color="black" />
              </TouchableOpacity>
            ),
            headerRightContainerStyle: {
              paddingRight: 8,
            },
          }}
        />
        <Tabs.Screen
          name="shifts"
          options={{
            title: 'My Shifts',
            tabBarIcon: ({ color }) => (
              <MaterialIcons name="schedule" size={32} color={color} />
            ),
            tabBarLabel: () => null,
          }}
        />
        <Tabs.Screen
          name="team"
          options={{
            title: 'Team',
            tabBarIcon: ({ color }) => (
              <MaterialIcons name="group" size={32} color={color} />
            ),
            tabBarLabel: () => null,
            headerRight: () => (
              <TouchableOpacity>
                <MaterialIcons name="add" size={32} color="black" />
              </TouchableOpacity>
            ),
            headerRightContainerStyle: {
              paddingRight: 8,
            },
          }}
        />
        <Tabs.Screen
          name="user/[id]"
          options={{
            title: 'Profile',
            href: {
              pathname: 'user/[id]',
              params: { id: '1' },
            },
            tabBarIcon: ({ color }) => (
              <MaterialIcons name="person" size={32} color={color} />
            ),
            tabBarLabel: () => null,
          }}
        />
      </Tabs>
    </Provider>
  )
}
