import { Text, useSx, View, H1, P, Row, A, FlatList } from 'dripsy'
import { memo, useCallback, useMemo } from 'react'
import { TextLink } from 'solito/link'
import { MotiLink } from 'solito/moti'

export function ShiftsScreen() {
  const sx = useSx()

  const shifts = [
    {
      id: '1',
      title: 'Shift 1',
      description: 'This is a description of the shift.',
      start: '2021-01-01T00:00:00.000Z',
      end: '2021-01-01T00:00:00.000Z',
    },
    {
      id: '2',
      title: 'Shift 2',
      description: 'This is a description of the shift.',
      start: '2021-01-01T00:00:00.000Z',
      end: '2021-01-01T00:00:00.000Z',
    },
    {
      id: '3',
      title: 'Shift 3',
      description: 'This is a description of the shift.',
      start: '2021-01-01T00:00:00.000Z',
      end: '2021-01-01T00:00:00.000Z',
    },
  ]

  const renderItem = useCallback(({ item }) => <Item item={item} />, [])
  const keyExtractor = useCallback((item) => item.id, [])

  return (
    <View
      sx={{ flex: 1, justifyContent: 'center', alignItems: 'center', width: '100%' }}
    >
      <FlatList
        data={shifts}
        renderItem={renderItem}
        keyExtractor={keyExtractor}
        sx={{p: 16, width: '100%'}}
      />
    </View>
  )
}

const Item = memo(({ item }: { item: any }) => (
  <View
    sx={{
      p: 16,
      backgroundColor: 'white',
      borderRadius: 8,
      mb: 16,
    }}
  >
    <Text sx={{ fontWeight: 'bold' }}>{item.title}</Text>
    <Text sx={{ color: 'gray.500' }}>{item.description}</Text>
    <Text sx={{ color: 'gray.500' }}>Start: {new Date(item.start).toLocaleString()}</Text>
    <Text sx={{ color: 'gray.500' }}>End: {new Date(item.end).toLocaleString()}</Text>
  </View>
))
