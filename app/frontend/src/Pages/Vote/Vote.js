import React, { Fragment } from 'react';
import NavBar  from '../../Components/Navbar'
import axios from 'axios'
import {Image, ListGroup, Container, Card, Row, Col }  from 'react-bootstrap'
import API from "../../Utils/API";
import showSpinner from '../../Components/Spinner';
import './Vote.css'
class Vote extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            previmages: null,
            images: null,
            user1: null,
            user2: null,
            isLoading: true,
        }
    }

    loadImage() {
        API.randomImages().then(value => {
            var userRequests = []
            userRequests.push(API.getImageUser(value[0].user))
            userRequests.push(API.getImageUser(value[1].user))
            axios.all(userRequests).then(axios.spread((...responses) => {
                console.log(responses)
                this.setState({
                    images: value,
                    user1: responses[0],
                    user2: responses[1],
                    isLoading: false
                })
            }))
        })
    }

    async componentDidMount() {
        this.loadImage()
    }

    vote(index){
        var winner_id = 0
        var loser_id = 0
        if(index == 0){
            winner_id = this.state.images[0].id;
            this.state.images[0].wins += 1
            loser_id = this.state.images[1].id;
            this.state.images[1].lost += 1;
        } else {
            winner_id = this.state.images[1].id;
            this.state.images[0].lost += 1
            loser_id = this.state.images[0].id;
            this.state.images[1].wins += 1;
        }
        this.setState({
            isLoading: true
        });
        API.vote(winner_id, loser_id).then(response => {
            var images = this.state.images
            this.loadImage()
            this.setState({
                previmages: images
            })
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

    winlost(elements){
        var win = parseInt(elements.wins); 
        var lost = parseInt(elements.lost); 
        return win.toString() + "/" + lost.toString();
    }

    showPrevImages(){
        if(this.state.previmages != null){
            return (
                <Col>
                    <b style={{fontSize:18, display: 'flex', alignItems: 'center', justifyContent: 'center'}}>RESULTS</b>
                    <Row style={{display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: "30px"}}>
                        <Col style={{display: 'flex', justifyContent: 'center', textAlign: 'center', flexDirection: 'column'}}>
                            <Image className="vote-previmage" src={this.state.previmages[0].image}/>
                            {this.columnText(this.winlost(this.state.previmages[0]), "WIN/LOST")}
                        </Col>
                        <Col style={{display: 'flex', justifyContent: 'center', textAlign: 'center', flexDirection: 'column'}}>
                            <Image className="vote-previmage" src={this.state.previmages[1].image}/>
                            {this.columnText(this.winlost(this.state.previmages[1]), "WIN/LOST")}
                        </Col>
                    </Row>
                </Col>
            )
        }
        return (
            <div></div>
        )
    }

    render(){
        if(this.state.isLoading == false){
            return (
                <Fragment>
                    <NavBar/>
                    <div className="App-home-page ">
                    <Container className="App-home-container">
                        {this.showPrevImages()}
                        <Row style={{display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: "30px"}}> 
                            <b style={{fontSize:28}}>{this.state.images[0].name}    vs    {this.state.images[1].name}</b>
                        </Row>
                        <Row style={{display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: "10px"}}>
                            <Image className="vote-image" src={this.state.images[0].image} onClick={() => this.vote(0)}/>
                            <Image className="vote-image" src={this.state.images[1].image} onClick={() => this.vote(1)}/>
                        </Row>
                    </Container>
                    </div>
                </Fragment>
            )
        }
        return <showSpinner/>
    }
}
export default Vote;