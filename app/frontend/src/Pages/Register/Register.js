import React from 'react';
import axios from 'axios';
import { Button, Form, Image, Card, Col } from 'react-bootstrap';
import {login, saveToken} from '../../Utils/Authentication'
import ImageUploading from "react-images-uploading";
import API from "../../Utils/API";

class Register extends React.Component {

  constructor(props) {
    super(props);
    this.state = { 
        firstname: "",
        lastname: "",
        email: "", 
        password1: "",
        password2: "",
        file: null,
        imagePreviewUrl: '',
        error: ''
    };
  }

  handlefirstname = event => {this.setState({ firstname: event.target.value })}
  handlelastname = event => {this.setState({ lastname: event.target.value })}
  handleEmailChange = event => {this.setState({ email: event.target.value })}
  handlePassword1 = event => {this.setState({ password1: event.target.value })}
  handlePassword2 = event => {this.setState({ password2: event.target.value })}

  _handleImageChange = (e) => {
    e.preventDefault();

    let reader = new FileReader();
    let file = e.target.files[0];

    reader.onloadend = () => {
      this.setState({
        file: file,
        imagePreviewUrl: reader.result
      });
    }

    reader.readAsDataURL(file)
  }

  handleRegister = () => {
    
    let formdata = new FormData()
    formdata.append('first_name', this.state.firstname)
    formdata.append('last_name', this.state.lastname)
    formdata.append('email', this.state.email)
    formdata.append('password1', this.state.password1)
    formdata.append('password2', this.state.password2)
    if(this.state.imagePreviewUrl)
      formdata.append('profilepicture', this.state.file, this.state.file.name);
    API.register(this.state.firstname, this.state.lastname, this.state.email, this.state.password1, this.state.password2, this.state.imagePreviewUrl ? this.state.file : null).then(response => {
      saveToken(response.key)
      API.getUserData().then(data => {
        login(data)
        this.props.history.push('/home');
      })
    }).catch(error => {
      console.log("error")
      console.log(error)
      var message = 'Check all the fields are correct'
      if(error.data.email)
        message = error.data.email
      if(error.data.non_field_errors)
        message = error.data.non_field_errors
      this.setState({
        error: message
      })
    });
  }
    
  render(){
    var imagePreview
    var imagePreviewUrl = this.state.imagePreviewUrl
    if (imagePreviewUrl) {
        imagePreview = (<Image src={imagePreviewUrl} roundedCircle height='100px' width='100px'/>);
      } else {
        imagePreview = (<Image src="https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSFr9oMl_MzaTa_7W8zPOhHCr42pVdiK4H8vvllcsG2WaMzJdG4&usqp=CAU" 
        roundedCircle 
        height='100px'
        width='100px'/>);
    } 
    return (
      <div className="Login-App">
        <Card className="card-login z-depth-5">
          <Card.Body>
          <Form>
              <Form.Group controlId="formfirstname" onChange={this.handlefirstname}>
                <Form.Label>First name</Form.Label>
                <Form.Control placeholder="Enter first name" />
              </Form.Group>

              <Form.Group controlId="formlastname" onChange={this.handlelastname}>
                <Form.Label>Last name</Form.Label>
                <Form.Control placeholder="Enter last name" />
              </Form.Group>

              <Form.Group controlId="formBasicEmail" onChange={this.handleEmailChange}>
                <Form.Label>Email address</Form.Label>
                <Form.Control type="email" placeholder="Enter email" />
              </Form.Group>

              <Form.Group controlId="formpassword1" onChange={this.handlePassword1}>
                <Form.Label>Password</Form.Label>
                <Form.Control type="password" placeholder="Enter password" />
              </Form.Group>

              <Form.Group controlId="formpassword2" onChange={this.handlePassword2}>
                <Form.Label>Repeat password</Form.Label>
                <Form.Control type="password" placeholder="Repeat password" />
              </Form.Group>

              <Form.Group controlId="formImage" onChange={this._handleImageChange}>
                <Form.Row>
                    <Col>
                        {imagePreview}
                    </Col>
                    <Col>
                        <Form.File 
                        id="custom-file"
                        label="Image profile"
                        custom
                        />
                    </Col>
                </Form.Row>
              </Form.Group>

              <Form.Group>
                <Button variant="primary" type="button" style={{width:"100%"}} onClick={this.handleRegister}>
                  Register
                </Button>
              </Form.Group>
              <p style={{color:"red"}}>{this.state.error}</p>
            </Form>
          </Card.Body>
        </Card>
      </div>
    );
  }
}
export default Register;