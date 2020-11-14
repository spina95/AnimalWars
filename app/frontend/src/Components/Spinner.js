import {Spinner} from 'react-bootstrap'
import React from 'react'
const showSpinner = () => {
    return (
        <Spinner animation="border" role="status">
            <span className="sr-only">Loading...</span>
        </Spinner>
    )
}
export default showSpinner;