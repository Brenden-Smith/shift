import { Provider } from 'app/provider'
import { Stack } from 'expo-router'
import { StatusBar } from 'expo-status-bar'

export default function Root() {
  return (
    <Provider>
      <StatusBar style="dark" />
      <Stack />
    </Provider>
  )
}
