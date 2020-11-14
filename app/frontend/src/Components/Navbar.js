import React from 'react'
import { BrowserRouter as Router, Switch, Route, useParams,} from "react-router-dom";
import { Navbar, Nav, NavDropdown, Form, FormControl, Button } from 'react-bootstrap';
import API from "../Utils/API"
import {currentUser, logout} from '../Utils/Authentication';
import Home from '../Pages/Home/Home';
class NavBar extends React.Component{

    search(){
        if(this.props.mode == "search"){
            return (
                <Form inline>
                    <FormControl type="text" placeholder="Search" value={this.props.value} className="mr-sm-2" onChange={this.handleChange.bind(this)} />
                </Form>
            )
        } 
        if(this.props.mode == "user"){
            return (
                <Navbar.Text>
                    <div style={{color:"white"}} onClick={this.handleLogout.bind(this)}>Logout</div>
                </Navbar.Text>
            )
        }
        return (
            <div></div>
        )
    }

    handleLogout(){
        this.props.callbackLogout()
    }

    handleChange(event) {
        let fleldVal = event.target.value;
        this.props.callbackFromParent(fleldVal);
    }

    render(){
        var currentuser = '/user/' + currentUser().id
        return(
            <div>
                <div className="row">
                    <div className="col-md-12">
                        <Router>
                            <Navbar bg="dark" variant="dark" expand="lg" fixed="top">
                                <Navbar.Brand href="/home">Animalwar</Navbar.Brand>
                                <Navbar.Toggle aria-controls="basic-navbar-nav" />
                                <Navbar.Collapse id="basic-navbar-nav">
                                    <Nav className="mr-auto">
                                    <Nav.Link href="/home">Home</Nav.Link>
                                    <Nav.Link href={currentuser}>User</Nav.Link>
                                    <Nav.Link href="/vote">Vote</Nav.Link>
                                    <Nav.Link href="/post">Post</Nav.Link>
                                    </Nav>
                                    {this.search()}
                                </Navbar.Collapse>
                            </Navbar>
                            <br />
                        </Router>
                    </div>
                </div>
            </div>
        )  
    }
}

export default NavBar;