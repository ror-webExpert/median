import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import { openModal, closeModal } from '../../actions/modal_actions';
import { signup } from '../../actions/sessions_actions';
import SessionForm from './session_form';

const mapStateToProps = ({ errors }) => {
  return {
    errors: errors.sessions,
    formType: 'Sign up',
    formHeading: "Join Median.",
    formDescription: "Create an account to receive great stories in your inbox, personalize your homepage, and follow authors and topics that you love.",
    formFooter: "No account?",
  };
};

const mapDispatchToProps = dispatch => {
  return {
    processForm: (user) => dispatch(signup(user)),
    otherForm: (
      <button className="small-footer-link" onClick={() => dispatch(openModal('Log in'))}>
        Login
      </button>
    ),
    closeModal: () => dispatch(closeModal()),
    demoLogin: () => dispatch(login({email: "guestuser@test.com", password: "password"}))
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(SessionForm);
