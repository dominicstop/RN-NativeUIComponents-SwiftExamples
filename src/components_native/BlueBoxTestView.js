import React from 'react';
import { requireNativeComponent, View, Text } from 'react-native';
 
const NativeBlueBoxTestView = requireNativeComponent('BlueBoxTestView');

export class BlueBoxTestView extends React.PureComponent {
  static proptypes = {
  };

  constructor(props){
    super(props);

    this.state = {
      counter: 0
    };
  };

  componentDidMount(){
    this.timer = setInterval(() => {
      this.setState((prevState) => ({
        counter: (prevState.counter + 1)
      }));
    }, 3000);
  };

  componentWillUnmount(){
    if(this.timer){
      clearInterval(this.timer);
    };
  };

  render() {
    const { counter } = this.state;
    return(
      <NativeBlueBoxTestView
        style={{ minWidth: 10, minHeight: 10 }}
        nativeID={'uniqueID'}
        {...this.props}
      >
        <Text style={{position: 'absolute'}}>
          {`child #0: ${counter} absolute style`}
        </Text>
        <Text>
          {`child #1 - ${counter}`}
        </Text>
        <View style={{position: 'absolute'}}>
          <View style={{ flex: 1, left: 0, top: 0 }}>
            <Text>
              {`Child #2 - 1: ${counter}`}
            </Text>
            <Text> Child #2 - 2 - this view is styled to </Text>
            <Text> Child #2 - 3 - be "postion: absolute" </Text>
            <Text> Child #2 - 4 - appears inside a modal </Text>
            <Text style={{flex: 1, backgroundColor: 'pink'}}>
              {'This will fill the screen'}
            </Text>
          </View>
        </View>
        
      </NativeBlueBoxTestView>
    );
  };
}