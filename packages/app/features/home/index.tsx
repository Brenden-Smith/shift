import { View, H1, P } from 'dripsy'

export function HomeScreen() {
  return (
    <View
      sx={{ flex: 1, justifyContent: 'center', alignItems: 'center', p: 16 }}
    >
      <H1 sx={{ fontWeight: '800' }}>Welcome to Shift.</H1>
      <View sx={{ maxWidth: 600 }}>
        <P sx={{ textAlign: 'center' }}>
          Shift is a scheduling application for EMTs and Paramedics.
        </P>
      </View>
      <View sx={{ height: 32 }} />
    </View>
  )
}
