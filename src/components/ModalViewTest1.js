import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { ModalView } from 'app/src/components_native/ModalView';
import * as Helpers from 'app/src/functions/helpers';

export class ModalViewTest1 extends React.PureComponent {
  async componentDidMount(){
    await Helpers.timeout(1000);

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

    await this.modal1.setVisibilty(true);

  };

  render(){
    return(
      <View>
        <ModalView 
          ref={r => this.modal1 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'😊'}
          </Text>
          <Text style={styles.textModal}>
            {'Hello #1'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal2 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'😄'}
          </Text>
          <Text style={styles.textModal}>
            {'Hello There #2'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal3 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'💖'}
          </Text>
          <Text style={styles.textModal}>
            {'ModalView Test #3'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal4 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'🥺'}
          </Text>
          <Text style={styles.textModal}>
            {'PageSheet Modal #4'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal5 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'🥰'}
          </Text>
          <Text style={styles.textModal}>
            {'Hello World Modal #5'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal6 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'😙'}
          </Text>
          <Text style={styles.textModal}>
            {'Hello World #6'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal7 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'🤩'}
          </Text>
          <Text style={styles.textModal}>
            {'Heyyy There #7'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal8 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'😃'}
          </Text>
          <Text style={styles.textModal}>
            {'Another Modal #8'}
          </Text>
        </ModalView>
        <ModalView 
          ref={r => this.modal9 = r} 
          containerStyle={styles.modalContainer}
        >
          <Text style={styles.textEmoji}>
            {'🏳️‍🌈'}
          </Text>
          <Text style={styles.textModal}>
            {'And Another Modal #9'}
          </Text>
        </ModalView>
      </View>
    );
    //#endregion
  };
};


const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  textEmoji: {
    fontSize: 64,
    marginBottom: 10,
  },
  textModal: {
    fontSize: 28,
    fontWeight: '800',
  },
});
