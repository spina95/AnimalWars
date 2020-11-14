import request from './Request'

const TOKEN_KEY = 'jwt';

const APIService = {

  login(email, password) {
    // Login
    let formdata = new FormData()
    formdata.append('email', email)
    formdata.append('password', password)
    return request({
      url: '/users/rest-auth/login/',
      method: 'POST',
      data: formdata,
    });
  },

  currentUserData(token){
    // Get current user data
    return request({
      url: '/users/rest-auth/user/',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token},
    });
  },

  register(firstname, lastname, email, password1, password2, file) {
    // Register
    let formdata = new FormData()
    formdata.append('first_name', firstname)
    formdata.append('last_name', lastname)
    formdata.append('email', email)
    formdata.append('password1', password1)
    formdata.append('password2', password2)
    if(file)
      formdata.append('profilepicture', file, file.name);
    return request({
      url: '/users/rest-auth/registration/',
      method: 'POST',
      headers: {
        'content-type': 'multipart/form-data'
      },
      data: formdata
    });
  }, 

  logout() {
    // Logout
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/users/rest-auth/logout/',
      method: 'POST',
      headers: {"Authorization": 'Token ' + token},
    });
  }, 

  getUserData() {
    // Return current user data
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/users/rest-auth/user/',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token}
    });
  }, 

  getImageInfo(image_id) {
    // Return data of an image
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/images/' + image_id,
      method: 'GET',
      headers: {"Authorization": 'Token ' + token},
    });
  }, 

  getHighestScoreImages() {
    // Return images with higher score
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/higherscore',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token}
    });
  }, 

  getLowerScoreImages() {
    // Return images with higher score
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/lowerscore',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token}
    });
  }, 

  getnewestImages() {
    // Return images with higher score
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/newestImages',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token}
    });
  }, 

  getImageUser(user_id) {
    // Return user data 
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/users/' + user_id,
      method: 'GET',
      headers: {"Authorization": 'Token ' + token},
    });
  }, 

  getUserImages(user_id) {
    // Return images of an user
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/profileimages',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token},
      params: {profile_id: user_id},
    });
  }, 

  searchTags(search, searchMode) {
    // Search images with tags
    const token = localStorage.getItem(TOKEN_KEY)
    var list = search.split(' ');
    list.pop()
    console.log(list)
    var params = new URLSearchParams();
    var mode = searchMode == 0 ? "descending" : searchMode == 1 ? "ascending" : "newest"
    params.append("order", mode)
    list.forEach(element => {
      params.append("tag", element)
    });
    
    return request({
      url: '/images/searchTag',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token},
      params: params
    });
  }, 

  imageTags(image_id) {
    // Return tags of an image
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/imageTags',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token},
      params: {image_id: image_id},
    });
  }, 

  randomImages() {
    // Return two random images
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/randomImages',
      method: 'GET',
      headers: {"Authorization": 'Token ' + token},
    });
  }, 

  vote(winner_id, loser_id) {
    // Return two random images
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/vote',
      method: 'POST',
      headers: {"Authorization": 'Token ' + token},
      params: {'winner_id': winner_id, 'loser_id': loser_id}
    });
  }, 

  postImage(image, title, user_id) {
    // Post image
    let fd= new FormData()
    fd.append('image', image.file)
    fd.append('name', title)
    fd.append('user', user_id)
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/images',
      method: 'POST',
      headers: {"Authorization": 'Token ' + token, 'Content-Type': 'multipart/form-data',},
      data: fd
    });
  }, 

  removeImage(image_id) {
    const token = localStorage.getItem(TOKEN_KEY)
    return request({
      url: '/images/images/' + image_id,
      method: 'DELETE',
      headers: {"Authorization": 'Token ' + token, 'Content-Type': 'multipart/form-data',},
    });
  },

  postTag(tag, image_id) {
    // Post tag
    const token = localStorage.getItem(TOKEN_KEY)
    let fd= new FormData()
    fd.append('name', tag)
    fd.append('image', image_id)
    return request({
      url: '/images/tags',
      method: 'POST',
      headers: {"Authorization": 'Token ' + token, 'Content-Type': 'multipart/form-data',},
      data: fd
    });
  }, 

}

export default APIService;