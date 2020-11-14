const TOKEN_KEY = 'jwt';

export const saveToken = (key) => {
    localStorage.setItem(TOKEN_KEY, key);
}
export const login = (user) => {
    localStorage.setItem('current_user', JSON.stringify(user));
}

export const currentUser = () => {
    var user = localStorage.getItem('current_user')
    return JSON.parse(user);
}

export const logout = () => {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem('current_user');
}

export const isLogin = () => {
    if (localStorage.getItem(TOKEN_KEY)) {
        return true;
    }

    return false;
}