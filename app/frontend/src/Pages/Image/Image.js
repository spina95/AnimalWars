import React, { Fragment } from 'react';
import NavBar  from '../../Components/Navbar'
import {Image, Button, Container, Card, Row, Col }  from 'react-bootstrap'
import API from "../../Utils/API";
import {currentUser} from '../../Utils/Authentication'

class ImageInfo extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            isLoading: true,
            image: null,
            user: null,
            tags: null
        };
    }

    async componentDidMount() {
        const { match: { params } } = this.props;
        var image_id = params.image_id
        API.getImageInfo(image_id).then(response => {
            console.log(response);
            API.getImageUser(response.user).then(user => {
                API.imageTags(image_id).then(tags => {
                    this.setState({
                        image: response,
                        user: user,
                        tags: tags,
                        isLoading: false
                    })
                })
            }) 
            
        })
    }

    winlost(element){
        var win = element.wins;
        var lost = element.lost;
        return win.toString() + "/" + lost.toString();
    }

    date(element){
        var d = new Date(element.uploaded_at);
        var month = new Array();
        month[0] = "Jan";
        month[1] = "Feb";
        month[2] = "Mar";
        month[3] = "Apr";
        month[4] = "May";
        month[5] = "Jun";
        month[6] = "Jul";
        month[7] = "Aug";
        month[8] = "Sep";
        month[9] = "Oct";
        month[10] = "Nov";
        month[11] = "Dec";
        var n = month[d.getMonth()];
        return d.getDate() + " " + month[d.getMonth()] + " " + d.getFullYear()
    }

    columnText = (value, title) => {
        return (
            <Col>
                <b style={{fontSize:20}}>{value}</b>
                <div>{title}</div>
            </Col>
        )
    }

    tags() {
        return (<Row>{
            this.state.tags.map((item, index) => (
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
        </Row>)
    }

    removeImage(){
        var url = '/user/' + currentUser().id
        API.removeImage(this.state.image.id).then((response) => {
            this.props.history.push(url);
        })
    }

    delete(){
        if(this.state.image.user == currentUser().id){
            return (
                <Button variant="danger" onClick={() => this.removeImage()}>Remove</Button>
            )
        }
    }

    render(){
        if(this.state.isLoading == false){
            return(
                <Fragment>
                    <NavBar/>
                    <div className="App-home-page ">
                    <Container className="App-home-container">
                        <div style={{display: 'flex', alignItems: 'center', justifyContent: 'center', flexDirection:'column'}}>
                            <b style={{fontSize:24, paddingBottom: 10}}>{this.state.image.name}</b>
                            <p style={{fontSize:24, color:'grey', paddingBottom: 10}}>{this.state.user.first_name} {this.state.user.last_name}</p>
                            {this.tags()}
                        </div>
                        
                        <Row style={{paddingTop: "20px", alignItems: 'center', justifyContent: 'center', alignContent: 'space-between', textAlign:'center'}}>
                            {this.columnText(this.state.image.score.toFixed(3), "score")}
                            {this.columnText(this.winlost(this.state.image), "win/lost")}
                            {this.columnText(this.date(this.state.image), "posted date")}
                        </Row>
                        <Image src={this.state.image.image} width="100%" style={{paddingBottom:"20px", paddingTop:"20px"}}/>
                        <Row style={{paddingTop: "20px", alignItems: 'center', justifyContent: 'center', alignContent: 'space-between', textAlign:'center'}}>
                            {this.delete()}
                        </Row>
                        
                    </Container>
                    </div>
                </Fragment>
            )
        }
        return(
            <div></div>
        )
    }
}
export default ImageInfo