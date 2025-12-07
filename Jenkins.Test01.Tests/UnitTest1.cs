namespace Jenkins.Test01.Tests
{
    public class UnitTest1
    {
        [Fact]
        public void AddTest()
        {
            int result = 2 + 2;
            Assert.Equal(4, result);
        }
    }
}