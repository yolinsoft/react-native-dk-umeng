import {
  NativeModules,
  Platform,
  DeviceEventEmitter,
  NativeAppEventEmitter,
  AppState
} from 'react-native';

const UMPushModule = NativeModules.UMPushModule;

let UMPush = {
  getDeviceToken() {
    return UMPushModule.getDeviceToken();
  },

  didReceiveMessage() {
    return new Promise((resolve, reject) => {
      this.addEventListener(UMPushModule.DidReceiveMessage, message => {
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
      this.addEventListener(UMPushModule.DidOpenMessage, message => {
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
      return NativeAppEventEmitter.addListener(eventName, event => {
        handler(event);
      });
    }
  }
};

module.exports = UMPush;
