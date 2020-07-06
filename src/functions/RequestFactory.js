

export class RequestFactory {
  static initialize(that){
    that.requestID  = 1;
    that.requestMap = {};
  };

  static getRequest(that, requestID){
    return that.requestMap[requestID];
  };

  static resolveRequest(that, {requestID, success, params}){
    try {
      const promise = that.requestMap[requestID];
      (success? promise.resolve : promise.reject)(params);
  
    } catch(error){
      console.log("RequestFactory, resolveRequest: failed");
      console.log(error);
    };
  };

  static resolveRequestFromObj(that, object){
    try {
      const { requestID, success = false, ...other } = object;
      const promise = that.requestMap[requestID];
      (success? promise.resolve : promise.reject)(other);
  
    } catch(error){
      console.log("RequestFactory, resolveRequest: failed");
      console.log(error);
    };
  };

  static newRequest(that){
    const requestID = that.requestID++;

    const promise = new Promise((resolve, reject) => {
      that.requestMap[requestID] = { resolve, reject };
    });

    return { requestID, promise };
  };
};