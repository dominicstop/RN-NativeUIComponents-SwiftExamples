import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { UIButton       } from 'app/src/components_native/UIButton';
import { UIPageView     } from 'app/src/components_native/UIPageView';
import { RedBoxTestView } from 'app/src/components_native/RedBoxTestView';
import { ChildTestView  } from 'app/src/components_native/ChildTestView';

export default class App extends React.Component {
  _render(){
    return(
      <View style={{flex: 1, backgroundColor: 'white'}}>
        <UIPageView style={{flex: 1}}>
          <View style={[styles.page, {alignItems: 'center', justifyContent: 'center', backgroundColor: 'red'}]}>
            <Text>Page 1</Text>
          </View>
          <View style={[styles.page, {alignItems: 'center', justifyContent: 'center', backgroundColor: 'blue'}]}>
            <Text>Page 2</Text>
          </View>
          <View style={[styles.page, {alignItems: 'center', justifyContent: 'center', backgroundColor: 'green'}]}>
            <Text>Page 3</Text>
          </View>
          <View style={[styles.page, {alignItems: 'center', justifyContent: 'center', backgroundColor: 'yellow'}]}>
            <Text>Page 4</Text>
          </View>
        </UIPageView>
      </View>
    );
  };

  render(){
    return (
      <View style={styles.container}>
        <RedBoxTestView
          style={{ width: 100, aspectRatio: 1 }}
          onClick={(params) => {
            console.log(params);
          }}
        />
        <ChildTestView
          style={{width: 100, height: 100, backgroundColor: 'grey'}}
        >
          <Text>Hello</Text>
        </ChildTestView>
        <UIButton
          style={{width: 100, height: 100, backgroundColor: 'orange'}}
          label2={'Test2'}
        />
      </View>
    );
  };
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  page: {
    ...StyleSheet.absoluteFillObject,
  },
});
