import 'bluetooth_state.dart';

BluetoothState parseBluetoothState(String state) {
  BluetoothState result;
  switch (state) {
    case "STATE_OFF":
      result = BluetoothState.STATE_OFF;
      break;
    case "STATE_TURNING_OFF":
      result = BluetoothState.STATE_TURNING_OFF;
      break;
    case "STATE_ON":
      result = BluetoothState.STATE_ON;
      break;
    case "STATE_TURNING_ON":
      result = BluetoothState.STATE_TURNING_ON;
      break;
    default:
      throw ArgumentError('Received invalid bluetooth state: $state');
  }

  return result;
}
