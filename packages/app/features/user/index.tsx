import { TextInput } from 'app/components/TextInput'
import { View, Row, Image, P, H1, SafeAreaView } from 'dripsy'
import { TouchableOpacity } from 'react-native'
import { createParam } from 'solito'

const { useParam } = createParam<{ id: string }>()

export function UserDetailScreen() {
  const [id] = useParam('id')

  return (
    <SafeAreaView sx={{ flex: 1, p: 16, m: 16 }}>
      <Row sx={{ alignItems: 'center' }}>
        <Image
          sx={{ width: 96, height: 96, borderRadius: 64 }}
          source={{ uri: 'https://picsum.photos/200/300' }}
        />
        <View
          sx={{
            flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
          }}
        >
          <H1>User Name</H1>
        </View>
      </Row>
      <View sx={{ mt: 16 }}>
        <P sx={{ mb: 1 }}>Email</P>
        <TextInput sx={{mb: 3}} />
        <P sx={{ mb: 1 }}>Medic ID</P>
        <TextInput editable={false} value="1234567890" />
      </View>
      <View sx={{
        position: 'absolute',
        bottom: 0,
        left: 0,
        width: '100%',
      }}>
        <TouchableOpacity>
          <View
            sx={{
              backgroundColor: 'green',
              height: 35,
              justifyContent: 'center',
              alignItems: 'center',
              borderRadius: 8,
            }}
          >
            <P sx={{ color: 'white' }}>Save</P>
          </View>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  )
}
