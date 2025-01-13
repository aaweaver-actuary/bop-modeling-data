import streamlit as st

def header():
    st.title('My Streamlit App')
    st.write('This is a simple app that demonstrates how to use Streamlit.')

def app():
    header()
    st.write('Hello, Streamlit!')

if __name__ == '__main__':
    app()
