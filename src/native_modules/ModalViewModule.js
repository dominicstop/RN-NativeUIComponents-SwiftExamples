import { NativeModules } from 'react-native';
import * as Helpers from 'app/src/functions/helpers';

const moduleName   = "ModalViewModule";
const NativeModule = NativeModules[moduleName];

const COMMAND_KEYS = {
  dismissModalByID: 'dismissModalByID'
};


export class ModalViewModule {
  static dismissModalByID(modalID = ''){
    const promise = new Promise((resolve, reject) => {
      try {
        NativeModule[COMMAND_KEYS.dismissModalByID](modalID, success => {
          (success? resolve : reject)();
        });

      } catch(error){
        console.log("ModalViewModule, dismissModalByID error:");
        console.log(error);
        reject();
      };
    });

    return Helpers.promiseWithTimeout(1000, promise);
  };
};