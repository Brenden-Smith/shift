import { DripsyTextInputProps } from '@dripsy/core/build/components/TextInput'
import { TextInput as DripsyTextInput } from 'dripsy'

export function TextInput(props: Partial<DripsyTextInputProps>) {
  return (
    <DripsyTextInput
      verticalAlign={undefined}
      inputMode={undefined}
      onPressIn={undefined}
      onPressOut={undefined}
      id={undefined}
      href={undefined}
      hrefAttrs={undefined}
      onClick={undefined}
      onPointerEnter={undefined}
      onPointerEnterCapture={undefined}
      onPointerLeave={undefined}
      onPointerLeaveCapture={undefined}
      onPointerMove={undefined}
      onPointerMoveCapture={undefined}
      onPointerCancel={undefined}
      onPointerCancelCapture={undefined}
      onPointerDown={undefined}
      onPointerDownCapture={undefined}
      onPointerUp={undefined}
      onPointerUpCapture={undefined}
      aria-label={undefined}
      aria-busy={undefined}
      aria-checked={undefined}
      aria-disabled={undefined}
      aria-expanded={undefined}
      aria-selected={undefined}
      aria-labelledby={undefined}
      aria-valuemax={undefined}
      aria-valuemin={undefined}
      aria-valuenow={undefined}
      aria-valuetext={undefined}
      aria-hidden={undefined}
      aria-live={undefined}
      aria-modal={undefined}
      role={undefined}
      accessibilityLabelledBy={undefined}
      accessibilityLanguage={undefined}
      autoComplete={undefined}
      cursorColor={undefined}
      {...props}
      sx={(theme) => ({
        p: 16,
        borderRadius: 8,
        backgroundColor: theme.colors.$backgroundSecondary,
        ...props.sx,
      })}
    />
  )
}
