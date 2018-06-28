import {
  NativeModules,
  Platform,
  DeviceEventEmitter,
  NativeEventEmitter,
  AppState
} from 'react-native';

const UMPushModule = NativeModules.UMPushModule;
const pushListener = new NativeEventEmitter(NativeModules.pushListener);

let UMPush = {
  getDeviceToken() {
    return UMPushModule.getDeviceToken();
  },

  didReceiveMessage() {
    return new Promise((resolve, reject) => {
      this.addEventListener('didReceiveMessage', message => {
        //处于后台时，拦截收到的消息
        if (AppState.currentState === 'background') {
          return;
        }
        resolve(message);
      });
    });
  },

  didOpenMessage() {
    return new Promise((resolve, reject) => {
      this.addEventListener('didOpenMessage', message => {
        resolve(message);
      });
    });
  },

  addEventListener(eventName, handler) {
    if (Platform.OS === 'android') {
      return DeviceEventEmitter.addListener(eventName, event => {
        handler(event);
      });
    } else {
      return pushListener.addListener(eventName, event => {
        handler(event);
      });
    }
  }
};

module.exports = UMPush;
