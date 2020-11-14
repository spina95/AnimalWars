import React, { Component } from 'react';
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import PrivateRoute from './Utils/PrivateRoute'
import Login from './Pages/Login/Login';
import Home from './Pages/Home/Home';
import User from './Pages/User/User';
import Vote from './Pages/Vote/Vote';
import Post from './Pages/Post/Post';
import ImageInfo from './Pages/Image/Image';
import Register from './Pages/Register/Register';

class App extends Component {

  render() {
    return (
      <BrowserRouter>
        <Switch>
          <Route component={Login} path="/" exact />
          <Route component={Register} path="/register" exact />
          <PrivateRoute component={Home} path="/home" exact />
          <PrivateRoute component={User} path="/user/:user_id"/>
          <PrivateRoute component={Vote} path="/vote"/>
          <PrivateRoute component={Post} path="/post"/>
          <PrivateRoute component={ImageInfo} path="/image/:image_id"/>
        </Switch>
      </BrowserRouter>
    );
  }
}
export default App;
