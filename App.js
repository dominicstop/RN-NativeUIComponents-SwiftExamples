import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { UIButton          } from 'app/src/components_native/UIButton';
import { UIPageView        } from 'app/src/components_native/UIPageView';
import { ChildTestView     } from 'app/src/components_native/ChildTestView';
import { RedBoxTestView    } from 'app/src/components_native/RedBoxTestView';
import { BlueBoxTestView   } from 'app/src/components_native/BlueBoxTestView';
import { ExampleUIPageView } from 'app/src/components_native/ExampleUIPageView';
import { ModalView } from 'app/src/components_native/ModalView';

import { UIPageViewTest1 } from 'app/src/components/UIPageViewTest1';

import * as Helpers from 'app/src/functions/helpers';


export default class App extends React.Component {

  async componentDidMount(){
    await this.modal1.setVisibilty(true);
    await this.modal2.setVisibilty(true);
    await this.modal3.setVisibilty(true);
    await this.modal4.setVisibilty(true);
    await this.modal5.setVisibilty(true);
    await this.modal6.setVisibilty(true);
    await this.modal7.setVisibilty(true);
    await this.modal8.setVisibilty(true);
    await this.modal9.setVisibilty(true);

    await this.modal9.setVisibilty(false);
    await this.modal8.setVisibilty(false);
    await this.modal7.setVisibilty(false);
    await this.modal6.setVisibilty(false);
    await this.modal5.setVisibilty(false);
    await this.modal4.setVisibilty(false);
    await this.modal3.setVisibilty(false);
    await this.modal2.setVisibilty(false);
    await this.modal1.setVisibilty(false);
  };

  render(){
    return(
      <View>
        <ModalView ref={r => this.modal1 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 1</Text>
        </ModalView>
        <ModalView ref={r => this.modal2 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 2</Text>
        </ModalView>
        <ModalView ref={r => this.modal3 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 3</Text>
        </ModalView>
        <ModalView ref={r => this.modal4 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 4</Text>
        </ModalView>
        <ModalView ref={r => this.modal5 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 5</Text>
        </ModalView>
        <ModalView ref={r => this.modal6 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 6</Text>
        </ModalView>
        <ModalView ref={r => this.modal7 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 7</Text>
        </ModalView>
        <ModalView ref={r => this.modal8 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 8</Text>
        </ModalView>
        <ModalView ref={r => this.modal9 = r} containerStyle={styles.modalContainer}>
          <Text style={styles.textModal}>Hello 9</Text>
        </ModalView>
      </View>
    );

    //#region 
    return(
      <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
        <BlueBoxTestView
        />
      </View>
    );
    return(
      <View style={{flex: 1, backgroundColor: 'white'}}>
        <ExampleUIPageView style={{flex: 1}}/>
      </View>
    );
    return(
      <View style={{flex: 1, backgroundColor: 'white'}}>
        <UIPageViewTest1/>
      </View>
    );
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
    //#endregion
  };
};

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
  modalContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  textModal: {
    fontSize: 24,
    fontWeight: '700',
  },
});
