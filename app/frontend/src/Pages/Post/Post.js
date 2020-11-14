import React, { Fragment } from 'react';
import NavBar  from '../../Components/Navbar'
import ImageUploading from "react-images-uploading";
import axios from 'axios'
import {Image, Form, Container, Button, Col}  from 'react-bootstrap'
import APIService from '../../Utils/API';
import {currentUser} from '../../Utils/Authentication'

class Post extends React.Component {
    
    url = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBw0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ8NDQ0NFREWFhURFRUYHSggGBolGxUVITEhJSkrOi46Fx8zODMtNyg5OisBCgoKDQ0NDg0NDisZFRktNzctLTcrNy03KzctLS0tLSstNzc3Ny0tNy03LTctLTc3LS0tLS03Ny0rLS0tKy03K//AABEIAJ8BPQMBIgACEQEDEQH/xAAYAAEBAQEBAAAAAAAAAAAAAAAAAQIDBv/EABcQAQEBAQAAAAAAAAAAAAAAAAARAQL/xAAXAQEBAQEAAAAAAAAAAAAAAAAAAQID/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A9xus7prOurK1KzSg3SsUoN0rFKDdKzUoN0rFEGqVkoNUrIDdKwUG6ViqDVKxVBqlZpQapWaUGqVmlBqlZqVRulYKDdSs0BqlZKDVKwoNZrWa541gL0xresaCCAKIAogCiCCiAKVAFEUAAAABUAFQBUAAAAogKIKKgACKAIoLjWM41gNdMa30xoM6AAAAAAAAAgAAAAKAAAAAAAAAIAAAAAAAAgAAKNY1jGN4DXTnrp0xoMhoAAAAAAgAAKAAAAAAAAAAAAACKgAAAACaqKACAAC43jGNYo30xrfTnoIAAAAAAAgAAoAAAAAAAAAAAAIAAAAACAAAAAAAuNYzig30xrfTGqICAoigAAAIAAKIoAAAAAAAAAIAAAAAIAqAAAAAAABjeMNYDfTGtdM6oyAAACiAKIoACAACiAKAAAACAqAAAAgAAAAACAKgAAAuNYxjeA10xrXTOqIAAAAAgKgCiAKIoAAAAAAAAAgAAAAgCAAAAgoqAAAguNYzjWA1rGt9MNAACKCAAAAAAAqAKAAAACAqAgAgKJVARUAABAAAAEAAAFxrGcawHTWNx13GdxoYhGoRBmEaiwGIRuEBiEahAZhGoQGYsWLAZg1CAyNQgMajXWJAQIQABBFIuCoNxIDI1EgMwaiQGSNQgMjUIIzCNQgJmNEWA//Z"

    constructor(props) {
        super(props);
        this.state = {
            image: null,
            title: null,
            currentTag: null,
            tags: [],
            isLoading: true,
            error: ''
        };
    }

    async componentDidMount() {

    }

    onChange = (image) => {
        // data for submit
        console.log(image);
        this.setState({
            image: image[0]
        })
    };

    uploadImage(){
        return (
            <ImageUploading
                onChange={this.onChange}
                maxFileSize={5}
                acceptType={["jpg", "gif", "png"]}
            > 
            {({ image, onImageUpload, onImageRemoveAll }) => (
            
            <div>
                <button onClick={onImageUpload}>Upload image</button>
                <button onClick={onImageRemoveAll}>Remove image</button>
            </div>
            )}
            </ImageUploading>
        )
    }

    handleTitleChange = event => {this.setState({ title: event.target.value })}
    handleTagChange = event => {this.setState({ currentTag: event.target.value })}

    insertTag(){
        if(this.state.currentTag != ""){
            var tags = this.state.tags
            tags.push(this.state.currentTag)
            this.setState({
                tags: tags
            })
        }
        console.log(this.state.image)
    }

    removeTag(index){
        var tags = this.state.tags
        tags.splice(index,1);
        this.setState({
            tags: tags
        })
    }

    postImage(){
        var user = currentUser()
        var url = '/user/' + currentUser().id
        if(this.state.image != null && this.state.title != null){
            APIService.postImage(this.state.image, this.state.title, user.id).then((response) => {
                console.log(response)
                if(this.state.tags.length != 0){
                    var tagrequests = []
                    this.state.tags.forEach(element => {
                        tagrequests.push(APIService.postTag(element, response.id))
                    })
                    axios.all(tagrequests).then(axios.spread((...responses) => {
                        this.props.history.push(url);
                    }))
                }
            })
        } else {
            this.setState({
                error: 'Insert an image and a title'
            })
        }
    }

    showImage(){
        if(this.state.image != null){
            return (
                <Image src={this.state.image.dataURL} width="100%"/>
            )
        }
        return <Image src={this.url} width="100%"/>
    }

    render(){
        return(
            <Fragment>
                <NavBar/>
                <div className="App-home-page ">
                <Container className="App-home-container">
                    <div style={{display: 'flex', alignItems: 'center', justifyContent: 'center', flexDirection:'column'}}> 
                        {this.showImage()}
                        {this.uploadImage()}
                        <Form style={{paddingTop:"20px"}} >
                            <Form.Group onChange={this.handleTitleChange} >
                                <Form.Control placeholder="Title" />
                            </Form.Group>
                            <Form.Group>
                            <Form.Row>
                                <Col>
                                    <Form.Control placeholder="Insert tag" onChange={this.handleTagChange} />
                                </Col>
                                <Col>
                                    <Button onClick={() => this.insertTag()} >Insert</Button>
                                </Col>
                            </Form.Row>
                            </Form.Group>
                            {this.state.tags.map((el, index) => {
                                return(
                                    <Form.Group>
                                    <Form.Row >
                                        <Col>
                                            <div>{el}</div>
                                        </Col>
                                        <Col>
                                            <Button onClick={() => this.removeTag(index)} >Remove</Button>
                                        </Col>
                                    </Form.Row>
                                    </Form.Group>
                                )
                            }
                            )}
                            <Form.Group>
                                <Button variant="success" style={{width:"100%"}} onClick={() => this.postImage()}>Publish</Button>
                            </Form.Group>
                            <b style={{color:'red'}}>{this.state.error}</b>
                        </Form>
                    </div>
                </Container>
                </div>
            </Fragment>
        )
    }
}
export default Post;