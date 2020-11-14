import React from 'react';
import axios from 'axios';
import { Button, Form, FormGroup, Card, Container } from 'react-bootstrap';
import {login, saveToken} from '../../Utils/Authentication'
import './Login.css'
import APIService from '../../Utils/API';

class Login extends React.Component {

  constructor(props) {
    super(props);
    this.state = { 
      email: '', 
      password: '',
      error: ''
    };
  }

  handleEmailChange = event => {this.setState({ email: event.target.value })}
  handlePasswordChange = event => {this.setState({ password: event.target.value })}

  handleLogin = (event) => {
    event.preventDefault();
    console.log(this.state.email)
    APIService.login(this.state.email, this.state.password).then(response => {
      console.log(response);
      saveToken(response.key)
      APIService.getUserData().then(data => {
        console.log(data)
        login(data)
        this.props.history.push('/home');
      })
    }).catch(error => {
      this.setState({
        error: 'Check the fields are correct'
      })
    });
  }

  handleRegister(){
    this.props.history.push('/register');
  }
    
  render(){
    return (
      <div className="Login-App">
        <Card className="card-login z-depth-5">
          <Card.Body>
          <Form onSubmit={this.handleLogin}>
              <Form.Group controlId="formBasicEmail" onChange={this.handleEmailChange}>
                <Form.Label>Email address</Form.Label>
                <Form.Control type="email" placeholder="Enter email" />
              </Form.Group>

              <Form.Group controlId="formBasicPassword" onChange={this.handlePasswordChange}>
                <Form.Label>Password</Form.Label>
                <Form.Control type="password" placeholder="Enter password" />
              </Form.Group>

              <Form.Group>
                <Button variant="primary" type="submit" style={{width:"100%"}}>
                  Login
                </Button>
              </Form.Group>

              <Form.Group>
                <Button variant="secondary" style={{width:"100%"}} onClick={() => this.handleRegister()}>
                  Register
                </Button>
              </Form.Group>

              <p style={{color:'red'}}>{this.state.error}</p>
            </Form>
          </Card.Body>
        </Card>
      </div>
    );
  }
}
export default Login;