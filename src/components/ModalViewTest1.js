import * as React from 'react';
import { StyleSheet, View, Text, Image } from 'react-native';

import { ModalView, UIBlurEffectStyles } from 'app/src/components_native/ModalView';
import * as Helpers from 'app/src/functions/helpers';

const TestModal = React.forwardRef((props, ref) => (
  <ModalView ref={ref} {...props}>
    <View style={styles.titleContainer}>
      <Text style={styles.textEmoji}>
        {props.emoji ?? "😊"}
      </Text>
      <Text style={styles.textModal}>
        {props.title ?? 'Hello #1'}
      </Text>
    </View>
    <View style={styles.textModalContainer}>
      <Text style={styles.textModalSubtitle}>
        {'UIBlurEffectStyle: '}
        <Text style={{fontWeight: 'bold'}}>
          {`${props.modalBGBlurEffectStyle}`}
        </Text>
      </Text>
    </View>
  </ModalView>
));

export class ModalViewTest1 extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      counter: 0,
      modalBGBlurEffectStyle: UIBlurEffectStyles.systemMaterialLight,
    };
  };

  async componentDidMount(){
    await Helpers.timeout(2000);

    await this.modal1.setVisibilty(true);
    await this.cycleBlurStyles();
    await Helpers.setStateAsync(this, {
      modalBGBlurEffectStyle: UIBlurEffectStyles.systemUltraThinMaterial,
    });

    await this.modal2.setVisibilty(true);
    await this.modal3.setVisibilty(true);
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

    await this.cycleBlurStyles();
    await Helpers.setStateAsync(this, {
      modalBGBlurEffectStyle: UIBlurEffectStyles.systemThinMaterial,
    });
  };

  cycleBlurStyles = async () => {
    for (const effectStyle of Object.keys(UIBlurEffectStyles)) {
      await Helpers.setStateAsync(this, { 
        modalBGBlurEffectStyle: effectStyle 
      });
      await Helpers.timeout(200);
    };
  };

  render(){
    return(
      <View 
        style={styles.rootContainer}
      >
        <Image
          style={styles.image}
          resizeMode={'cover'}
          source={require('app/assets/images/macos11_wallpaper.jpg')}
        />
        <TestModal
          ref={r => this.modal1 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'😊'}
          title={'Hello #1'}
        />
        <TestModal
          ref={r => this.modal2 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'😄'}
          title={'Hello There #2'}
          isModalInPresentation={true}
        />
        <TestModal
          ref={r => this.modal3 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'💖'}
          title={'ModalView Test #3'}
          isModalBGTransparent={false}
          isModalInPresentation={true}
        />
        <TestModal
          ref={r => this.modal4 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'🥺'}
          title={'PageSheet Modal #4'}
          isModalInPresentation={true}
        />
        <TestModal
          ref={r => this.modal5 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'🥰'}
          title={'Hello World Modal #5'}
          isModalInPresentation={true}
        />
        <TestModal
          ref={r => this.modal6 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'😙'}
          title={'Hello World #6'}
          isModalInPresentation={true}
        />
        <TestModal
          ref={r => this.modal7 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'🤩'}
          title={'Heyyy There #7'}
          isModalInPresentation={true}
        />
        <TestModal
          ref={r => this.modal8 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'😃'}
          title={'Another Modal #8'}
          isModalInPresentation={true}
        />
        <TestModal
          ref={r => this.modal9 = r}
          containerStyle={styles.modalContainer}
          modalBGBlurEffectStyle={this.state.modalBGBlurEffectStyle}
          emoji={'🏳️‍🌈'}
          title={'And Another Modal #9'}
          isModalInPresentation={true}
        />
      </View>
    );
    //#endregion
  };
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
    padding: 40,
  },
  image: {
    flex: 1,
    alignSelf: 'center',
    justifyContent: 'center',
    width: 315,
    borderRadius: 20,
  },
  modalContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  titleContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'white',
    padding: 25,
    borderRadius: 15,
  },
  textEmoji: {
    fontSize: 64,
    marginBottom: 10,
  },
  textModal: {
    fontSize: 28,
    fontWeight: '800',
  },
  textModalContainer: {
    marginTop: 25,
    backgroundColor: 'white',
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 10,
  },
  textModalSubtitle: {
  }
});
