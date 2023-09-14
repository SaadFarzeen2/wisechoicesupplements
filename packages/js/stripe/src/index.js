import React from 'react';
import ReactDOM from 'react-dom';
import {loadStripe} from '@stripe/stripe-js';
import {
  CardElement,
  Elements,
  useStripe,
  useElements,
} from '@stripe/react-stripe-js';

import './index.css';

const CheckoutForm = (props) => {
  const stripe = useStripe();
  const elements = useElements();

  const handleSubmit = async (event) => {
    event.preventDefault();

    if (elements == null) {
      return;
    }

    const {source} = await stripe.createSource(elements.getElement(CardElement), {type: 'card'});
    console.log(source?.id);

    if (source && source.id) {
      window?.Flutter_Cirilla?.postMessage(source.id);
    }

  };

  const style = {
    base: {},
    invalid: {}
  };

  return (
    <form onSubmit={handleSubmit}>
      <div className="card" style={{ borderColor: props.borderColor }}>
        <CardElement options={{style, hidePostalCode: true}}/>
      </div>
      <button type="submit" disabled={!stripe || !elements} className="btn"
              style={{color: props.btnColor, backgroundColor: props.btnBg}}>
        {props.txtPay}
      </button>
    </form>
  );
};

CheckoutForm.defaultProps = {
  txtPay: 'Pay',
  btnBg: '#333333',
  btnColor: '#ffffff',
  borderColor: '#ddd'
}

const App = () => {

  const url_string = window.location.href;
  const url = new URL(url_string);
  const pk = url.searchParams.get("pk");
  let props = {};
  url.searchParams.forEach((value, key) => {
    props = {...props, [key]: value}
  });

  const stripePromise = loadStripe(pk ?? 'pk_test_6pRNASCoBOKtIshFeQd4XMUh');
  return (
    <Elements options={{appearance: {theme: 'stripe'}}} stripe={stripePromise}>
      <CheckoutForm {...props} />
    </Elements>
  );

};

ReactDOM.render(<App/>, document.getElementById("root"));
