import React, { Fragment } from 'react';
import NavBar  from '../../Components/Navbar'
import {Image, ListGroup, Container, Card, Row, Col }  from 'react-bootstrap'
import {currentUser, logout} from '../../Utils/Authentication'
import './User.css'
import API from "../../Utils/API";
import Gallery from 'react-grid-gallery';
import showSpinner from '../../Components/Spinner';

class User extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            isLoading: true,
            currentImage: 0,
            user: null
        };
        this.onCurrentImageChange = this.onCurrentImageChange.bind(this);
    }

    async componentDidMount() {
        const { match: { params } } = this.props;
        var currentuser = currentUser()
        if(params.user_id === currentuser.id) {
            API.getUserImages(params.user_id).then((images) => {
                this.setState({
                    user: currentUser,
                    images: images,
                    isLoading: false
                })
            })
        } else {
            API.getImageUser(params.user_id).then((value) => {
                console.log(value)
                API.getUserImages(params.user_id).then((images) => {
                    this.setState({
                        user: value,
                        images: images,
                        isLoading: false
                    })
                })
            })
        }
    }

    handlelogout(){
        API.logout().then(value => {
            logout()
            this.props.history.push("/");
        })
    }

    columnText = (value, title) => {
        return (
            <Col>
                <b style={{fontSize:20}}>{value}</b>
                <div>{title}</div>
            </Col>
        )
    }

    average(elements){
        var sum = 0;
        for( var i = 0; i < elements.length; i++ ){
            sum += parseFloat(elements[i].score); 
        }
        if(sum == 0)
            return 0
        return sum/elements.length;
    }

    winlost(elements){
        var win = 0;
        var lost = 0;
        for( var i = 0; i < elements.length; i++ ){
            win += parseInt(elements[i].wins); 
            lost += parseInt(elements[i].lost); 
        }
        return win.toString() + "/" + lost.toString();
    }

    onCurrentImageChange(index) {
        this.setState({ currentImage: index });
    }

    openImage(){
        var index = this.state.currentImage
        var url = '/image/' + this.state.images[index].id
        console.log(this.state.images[index])
        this.props.history.push(url);
    }

    createTable = (images) => {
        var IMAGES = [];
        images.map((el) => {
            var a = {
                src: el.image,
                thumbnail: el.image,
                thumbnailWidth: 200,
                thumbnailHeight: 200
            }
            IMAGES.push(a)
        })
        return (
            <div style={{
                paddingTop: "30px",
                display: "block",
                minHeight: "1px",
                width: "100%",
                overflow: "auto"}}>
                <Gallery
                    images={IMAGES}
                    enableLightbox={true}
                    enableImageSelection={false}
                    currentImageWillChange={this.onCurrentImageChange}
                    onClickImage={() => this.openImage()}
                />
            </div>
        );
    }

    columnText = (value, title) => {
        return (
            <Col>
                <b style={{fontSize:20}}>{value}</b>
                <div>{title}</div>
            </Col>
        )
    }

    render(){
        if(this.state.isLoading == false){
            return(
                <Fragment>
                    <NavBar mode="user" callbackLogout={() => this.handlelogout()}/>
                    <div className="App-home-page">
                    <Container className="App-home-container">
                        <div style={{display: 'flex', alignItems: 'center', justifyContent: 'center', flexDirection:'column'}}>      
                                <Image 
                                    src={this.state.user.profilepicture}
                                    resizeMode= 'contain'
                                    width= "150"
                                    height= "150"
                                    style={{borderRadius: 150/ 2,}} 
                                />
                                <b style={{fontSize: 24}}>{this.state.user.first_name} {this.state.user.last_name}</b>
                        </div>
                        <Row style={{alignItems: 'center', justifyContent: 'center', alignContent: 'space-between', textAlign:'center'}}>
                            {this.columnText(this.state.images.length, "posted")}
                            {this.columnText(this.average(this.state.images).toFixed(3), "score average")}
                            {this.columnText(this.winlost(this.state.images), "wins/lost")}
                        </Row>
                        
                        <div>{this.createTable(this.state.images)}</div>
                  
                    </Container>
                    </div>
                </Fragment>
            )
        }
        return(
            <showSpinner/>
        )
    }
}
export default User