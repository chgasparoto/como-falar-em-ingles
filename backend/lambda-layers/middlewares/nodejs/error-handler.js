module.exports = () => {
  const errorHandler = async (request) => {
    return {
      statusCode: 500,
      body: "Something went wrong",
      headers: {
        "Content-Type": "application/json",
      },
    };
  };

  return {
    onError: errorHandler,
  };
};
