import React, { Fragment } from 'react';
import {Image, ListGroup, Container, Card, Row, Col }  from 'react-bootstrap'
import { useHistory } from "react-router-dom";
import axios from 'axios';
import API from "../../Utils/API";
import NavBar  from '../../Components/Navbar'
import './Home.css'

class Home extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            selectedMode: 0,
            isLoading: true,
            images: null,
            searchText: "",
            tags: null,
        };
    }

    async componentDidMount() {
        try {
            await API.getHighestScoreImages().then(response => {
                var userRequests = []
                var tagRequests = []
                response.forEach(element => {
                    userRequests.push(API.getImageUser(element.user))
                    tagRequests.push(API.imageTags(element.id))
                })
                this.setState ({
                    images: response,
                })    
                axios.all(userRequests).then(axios.spread((...responses) => {
                    axios.all(tagRequests).then(axios.spread((...tags) => {
                        console.log(tags)
                        this.setState({
                            users: responses,
                            tags: tags,
                            isLoading: false
                        })
                    }))
                }))
            })
        } catch (e) {
            console.log(`Axios request failed: ${e}`);
        }
    }

    searchTags(images){
        var userRequests = []
        var tagRequests = []
        images.forEach(element => {
            userRequests.push(API.getImageUser(element.user))
            tagRequests.push(API.imageTags(element.id))
        })
        axios.all(userRequests).then(axios.spread((...responses) => {
            axios.all(tagRequests).then(axios.spread((...tags) => {
                console.log(tags)
                this.setState({
                    users: responses,
                    tags: tags,
                    images: images,
                    isLoading: false
                })
            }))
        }))
    }

    search(text, mode){
        var images = []
        var searchText = text
        var searchMode = mode
        console.log(text)
        if(text == ""){
            console.log("cerca")
            if(searchMode == 0)
                API.getHighestScoreImages().then(images => {
                    console.log("higher")
                    this.searchTags(images)
                })
            if(searchMode == 1)
                API.getLowerScoreImages().then(images => {
                    this.searchTags(images)
                })
            if(searchMode == 2)
                API.getnewestImages().then(images => {
                    this.searchTags(images)
                })
        } else {
            var occurence = searchText.length  - searchText.split(" ").join("").length;
            var length = searchText.split(" ").length
            if(searchText.split(" ").includes(""))
                length -= 1
            console.log("occurence: " + occurence + " length: " + length)
            if(occurence == length){
                console.log("esegui")
                API.searchTags(text, searchMode).then(images => {
                    console.log(images)
                    this.searchTags(images)
                })
            } else {
                return null
            }
        }
    }

    navigateUser(user){
        var ulr = '/user/' + user.id
        this.props.history.push(ulr);
    }

    selectMode(mode) {
        console.log(mode)
        this.setState({
            isLoading: true,
        })
        if(mode == 0){
            console.log("set")
            this.setState({
                selectedMode: 0,
            })
        }
        if(mode == 1){
            this.setState({
                selectedMode: 1,
            })
        }
        if(mode == 2){
            this.setState({
                selectedMode: 2,
            })
        }
        this.search(this.state.searchText, mode)
    }

    showImageInfo(item){
        var url = '/image/' + item.id
        this.props.history.push(url);
    }

    searchText = (text) => {
       this.setState({
           searchText: text
       })
       this.search(text, this.state.selectedMode)
    }

    listComponent = (item, index) => {
        console.log(this.state.users[index])
        return (
            <Col>
                <Row style={{paddingBottom:16, paddingTop: 40, paddingLeft:15, justifyContent:'space-between'}}> 
                    <div style={{display: 'flex', alignItems: 'center'}}>
                        <Image 
                            src={this.state.users[index].profilepicture}
                            style={{width: 50, height: 50, borderRadius: 50/ 2,}} 
                            onClick={() => this.navigateUser(this.state.users[index])}
                        />
                        &nbsp;
                        <b>{item.name}</b>
                        <div>&nbsp;|&nbsp;</div>
                        {this.state.users[index].first_name} {this.state.users[index].last_name}
                    </div>
                    <div style={{display: 'flex', alignItems: 'center'}}>
                        <Col style={{textAlign:'center', verticalAlign:'middle'}}>   
                            <b style={{fontSize:18, height:"100px"}}>{item.score.toFixed(3)}</b>
                            <div>score</div>
                        </Col>
                    </div>
                </Row>
                <Row>{
                    this.state.tags[index].map((item, index) => (
                        <div style={{ 
                            fontSize: 14,
                            border:'solid',
                            borderWidth: 1, 
                            borderRadius: 15,
                            borderColor: 'black',
                            padding: '2px 8px 2px 8px',
                            marginLeft: '4px',
                            marginRight: '4px',
                            marginBottom: '8px'
                            }}>
                            {item.name}
                        </div>
                    ))}
                </Row>
                <Image src={item.image} style={{width: '100%',}} onClick={() => this.showImageInfo(item)}/>
            </Col>
        )
    }

    render(){
        if(this.state.isLoading === false){
            return(
                <Fragment>
                    <NavBar mode="search" value={this.state.searchText} callbackFromParent={this.searchText}/>
                    <div className="App-home-page ">
                    <Container className="App-home-container">
                        <Row style={{flex: 1, alignItems: 'center', justifyContent: 'center', alignContent: 'space-between', textAlign:'center'}}>
                            <Col style={{fontWeight: this.state.selectedMode == 0 ? 'bold' : 'normal'}} onClick={() => this.selectMode(0)}>Higher score</Col>
                            <Col style={{fontWeight: this.state.selectedMode == 1 ? 'bold' : 'normal'}} onClick={() => this.selectMode(1)}>Lower score</Col>
                            <Col style={{fontWeight: this.state.selectedMode == 2 ? 'bold' : 'normal'}} onClick={() => this.selectMode(2)}>Newest</Col>
                        </Row>
                        <ListGroup>{
                            this.state.images.map((item, index) => (
                                this.listComponent(item, index)
                            ))}
                        </ListGroup>
                    </Container>
                    </div>
                </Fragment>
            )
        }
        return (
            <div></div>
        )
    }
}
export default Home