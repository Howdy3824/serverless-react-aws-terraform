import React, { useEffect, useState } from "react";
import { PageHeader, Spin, Card, Input, Button } from "antd";
import axios from "axios";

const CommentsList = ({ todoId }) => {
  const initialFormState = { content: "" };
  const [formState, setFormState] = useState(initialFormState);
  const [comments, setComments] = useState([]);
  const [loadingComplete, setloadingComplete] = useState(true);
  const apiEndpoint = process.env.REACT_APP_API_ENDPOINT;
  useEffect(() => {
    fetchComments();
  }, []);

  function setInput(key, value) {
    setFormState({ ...formState, [key]: value });
  }

  async function fetchComments() {
    try {
      const res = await axios.get(`${apiEndpoint}/comments?todoId=${todoId}`);
      setComments(res.data.Items);
      setloadingComplete({ loadingComplete: true });
    } catch (err) {
      console.log("error fetching comments");
    }
  }

  async function addComment() {
    try {
      if (!formState.content) return;
      const comment = {
        ...formState,
        todoId
      };
      setFormState(initialFormState);

      const config = {
        headers: {
          "Content-Type": "application/json"
        }
      };
      const body = JSON.stringify(comment);
      await axios.post(`${apiEndpoint}/comments`, body, config);
      fetchComments();
    } catch (err) {
      console.log("error creating comment:", err);
    }
  }

  //   async function removeComment(id) {
  //     try {
  //       const commentDetails = {
  //         id
  //       };
  //       setComments(comments.filter(comment => comment.id !== id));
  //       await API.graphql(
  //         graphqlOperation(deleteComment, { input: commentDetails })
  //       );
  //     } catch (err) {
  //       console.log("error removing todo:", err);
  //     }
  //   }

  return (
    <div>
      <PageHeader
        className="site-page-header"
        title="Comments"
        style={styles.header}
      />
      <div>
        <Input
          onChange={event => setInput("content", event.target.value)}
          value={formState.content}
          placeholder="Comment"
          style={styles.input}
        />
        <Button onClick={addComment} type="primary" style={styles.submit}>
          Add
        </Button>
      </div>
      {loadingComplete ? (
        <div>
          {comments.map((comment, index) => (
            <Card
              key={comment.id ? comment.id.S : index}
              title={comment.content.S}
              style={{ width: 300 }}
            >
              <Button type="primary" onClick={() => console.log("delete")}>
                Delete
              </Button>
            </Card>
          ))}
        </div>
      ) : (
        <Spin />
      )}
    </div>
  );
};

const styles = {
  input: {
    margin: "10px 0"
  },
  submit: {
    margin: "10px 0",
    marginBottom: "20px"
  },
  header: {
    paddingLeft: "0px"
  }
};

export default CommentsList;
