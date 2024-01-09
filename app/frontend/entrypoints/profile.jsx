// /frontend/entrypoints/profile.jsx
import React from 'react';
import ReactDOM from 'react-dom';
import ProfileHeading from '../components/ProfileHeading.jsx';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<ProfileHeading />, document.getElementById('profile-root'));
});
/*
<div id="profile-root"></div>
<%= vite_javascript_tag 'profile.jsx' %>

 */
